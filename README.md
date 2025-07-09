# Presentations

## RailsConf 2025
- [railsconf2025/README.md](railsconf2025/README.md)

## PASS Data Community Summit
- [pass2024/README.md](pass2024/README.md)

## Presentations with Markdown
> Create decks like a hacker!

Quote inspired by: [blog like a hacker](https://tom.preston-werner.com/2008/11/17/blogging-like-a-hacker.html)

Often a slide deck is the best way to present information. Since I'm keeping notes in Markdown anyway, Marp allows me to add a minimal amount of formatting to create a slide deck presentation, and export it to a PDF.

## Instructions
Made with [Marp: Markdown Presentation Ecosystem](https://marp.app).

Visually previewed with VS Code:
* `Command-K + V` opens a side-by-side preview of the `.md` file
* `Shift-Command-V` opens the preview in the same window
* Top right menu "Export slide deck" to export a PDF, or export from the command line (preferred)
* Typically I upload slides PDF to Speaker Deck! ([speakerdeck.com/andyatkinson](https://speakerdeck.com/andyatkinson))

## Tips
* Pick a built-in [theme](https://github.com/marp-team/marp-core/tree/main/themes)!
* Marp supports global and local directives, applying to all slides or individual slides
  * Individual slide directives use HTML comments, e.g. `<!-- backgroundColor: aqua -->`
  * Scope changes to the slide only with an underscore (spot directive), e.g. `<!-- _backgroundColor -->`
* For backgrounds, consider a CSS gradients: <https://www.eggradients.com>
* For rounded corners, JS Fiddle [happy face rounded corners](http://thenewcode.com/431/Simple-CSS-Masks-Images-with-Rounded-Corners)
* Used <https://imgur.com> for image uploads, but usually keep images locally in `images` directory
- Crunch down big PNG, JPG, AVIF, and WEBP images using imagemagick (`magick` command)
* Transitions: <https://github.com/marp-team/marp-cli/issues/382>
* For HTML, add `--html` option on export: <https://www.hashbangcode.com/article/seven-tips-getting-most-out-marp#using-html-in-slides>
* In Vim, yank buffer to clipboard: `:%w !pbcopy`
* Open a terminal from Vim with `:term` and then navigate with `Ctrl-W h/j/k/l`

## marp-cli
Install:
```sh
brew install marp-cli
```

Example use to generate PDF and fill in metadata:
```sh
marp --pdf \
    --title "Partitioning 1 Billion Rows Without Downtime" \
    --description "Range Partitioning Case Study with Rails and pgslice" \
    --html --author "Andrew Atkinson" \
    --keywords "PostgreSQL, Partitioning, Scaling, Performance, Ruby on Rails, Ruby" \
    --url "https://bit.ly/PartPG2023" \
    --allow-local-files partitioning-concept-to-reality-case-study.md
```

This will produce a PDF file.

## Content Links
* PostgreSQL logo: <https://i.imgur.com/m5OLczS.png>
* Rails Logo: <https://twitter.com/rails/status/689480911432249345/photo/1>

## Diagrams
Draw.io
- Link items together so they can be re-positioned and preserve links

## Footnotes
Not directly supported in Marp Slides. Community:
- <https://github.com/orgs/marp-team/discussions/150#discussioncomment-7127819>

What I did was use HTML footnotes, then keep a CSV mapping of number to link, then a Ruby script produces an HTML list of links.

## Tools
To install on macOS:
```sh
brew install shellcheck
```

Run shellcheck:
```sh
shellcheck create_db.sh
```

## VS Code
- Choose "Trust", not Restricted Mode, which doesn't support all the HTML

## Magick
```sh
magick images/pghero.png -resize 50% -quality 85 images/pghero.jpg
```
