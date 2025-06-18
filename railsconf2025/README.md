# RailsConf 2025

Populate footnote links:
```sh
./footnote_fixer.rb 10_mistakes.md | pbcopy
```

Create PDF:
```sh
marp --pdf --html --author "Andrew Atkinson" --allow-local-files 10_mistakes.md
```

Convert images:
```sh
brew install imagemagick
magick aaron.png -resize 50% -quality 85 aaron-small.jpg
```

VS Code:
- Choose "trusted mode" to render all HTML

## 10 Mistakes
1. Infrequent Releases
2. DB Inexperience
3. Speculative DB Defaults
4. Missing DB Monitoring
5. ORM Pitfalls
6. DDL Fear
7. Excessive Data Access
8. No Data Archival
9. No DB Maintenance
10. Rejecting Mechanical Sympathy
