#!/usr/bin/env ruby

require 'csv'
require 'set'
require 'net/http'
require 'uri'

class FootnoteFixer
  def initialize(full_text, file_path)
    @full_text = full_text
    @file_path = file_path
  end

  def perform
    footnotes = extract_between(@full_text, "{{", "}}").first
    rows = CSV.parse(footnotes, headers: false).reject(&:empty?).sort # remove spaces, sort
    duplicates = rows.map{|r| r[1]}.tally.select { |_, count| count > 1 }.keys # detect duplicates so they can be fixed
    if duplicates.any?
      puts "found duplicates: #{duplicates}"
      puts "exiting."
      exit
    end

    # check_link_status(rows)

    # this should gsub all the footnotes
    # and append the HTML footnotes
    replace_footnote_inner_text(rows)

    new_html = create_html_list(rows)

    new_content = @full_text.concat(new_html)

    File.write(@file_path, new_content)
  end

  private

  def check_link_status(rows)
    rows.each_with_index do |row, idx|
      original_id = row[0]
      url = row[1]
      index = idx + 1
      uri = URI.parse("https://#{url}")
      response = Net::HTTP.get_response(uri)
      unless response.is_a?(Net::HTTPSuccess)
        puts "Found a bad link #{uri}, got response: #{response.code}"
      end
    end
  end

  def replace_footnote_inner_text(rows)
    rows.each_with_index do |row, idx|
      original_idx = row[0]
      url = row[1]
      new_index = idx + 1

      # pattern must match the original_idx
      # (?<id>\d+): Named capture for the footnote number in the href.
      # (?<text>\d+): Named capture for the text inside the anchor.
      pattern = /footnote-(?<id>#{original_idx})">(?<text>\d+)<\/a>/

      # replace the footnote HTML <a> value "1" in the document
      # using the new_index value
      @full_text.gsub!(pattern) do |match|
         orig_id = Regexp.last_match[:id]
         inner_text = Regexp.last_match[:text]
         new_content = "footnote-#{orig_id}\">#{new_index}</a>"
         puts
         puts "For original id: #{orig_id}"
         puts "Replacing inner text: #{inner_text}"
         puts "With new index: #{new_index}"
         puts "match: #{match}"
         puts "new_content: #{new_content}"
         puts
         new_content
      end
    end
  end

  # assumes sorted order
  def create_html_list(rows)
    html = "<div class='footnote'><ul class='two-column-list'>"
    rows.each_with_index do |row, idx|
      original_idx = row[0]
      url = row[1]
      new_index = idx + 1

      html += <<~ROW
        <li id='footnote-#{original_idx}'>
          #{new_index}. <a href='https://#{url}'>#{url}</a>
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

  FootnoteFixer.new(full_text, file_path).perform

rescue => e
  puts "Failed to read the file: #{e.message}"
  exit 1
end
