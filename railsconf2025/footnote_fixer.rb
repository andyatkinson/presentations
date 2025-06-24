#!/usr/bin/env ruby

require 'csv'
require 'set'
require 'net/http'
require 'uri'

class FootnoteFixer
  def initialize(full_text)
    @full_text = full_text
  end

  def perform
    footnotes = extract_between(@full_text, "{{", "}}").first
    rows = CSV.parse(footnotes, headers: false).reject(&:empty?)
    duplicates = rows.map{|r| r[1]}.tally.select { |_, count| count > 1 }.keys
    if duplicates.any?
      puts "found duplicates: #{duplicates}"
      puts "exiting."
      exit
    end

    # check_link_status(rows)

    puts create_html_list(rows)
  end

  private

  def check_link_status(rows)
    rows.each do |row|
      url = row[1]
      uri = URI.parse("https://#{url}")
      response = Net::HTTP.get_response(uri)
      unless response.is_a?(Net::HTTPSuccess)
        puts "Found a bad link #{uri}, got response: #{response.code}"
      end
    end
  end

  def create_html_list(rows)
    html = "<div class='footnote'><ul class='two-column-list'>"
    rows.each do |row|
      idx = row[0]
      url = row[1]
      html += <<~ROW
        <li id='footnote-#{idx}'>
          #{idx}. <a href='https://#{url}'>#{url}</a>
        </li>
      ROW
    end
    html += '</ul></div>'
  end

  def extract_between(text, start_delim, end_delim)
    pattern = /#{Regexp.escape(start_delim)}(.*?)#{Regexp.escape(end_delim)}/m
    text.scan(pattern).flatten
  end
end

# Check if a file path argument was provided
if ARGV.empty?
  puts "Usage: #{__FILE__} <file_path>"
  exit 1
end

file_path = ARGV[0]

# Check if the file exists and is readable
unless File.exist?(file_path) && File.readable?(file_path)
  puts "Error: File not found or is not readable: #{file_path}"
  exit 1
end

# Read and print the contents of the file
begin
  full_text = File.read(file_path)

  FootnoteFixer.new(
    full_text
  ).perform

rescue => e
  puts "Failed to read the file: #{e.message}"
  exit 1
end
