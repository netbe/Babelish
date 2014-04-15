[![Build Status](https://secure.travis-ci.org/netbe/Babelish.png?branch=master)](http://travis-ci.org/netbe/Babelish)
[![Code Climate](https://codeclimate.com/github/netbe/Babelish.png)](https://codeclimate.com/github/netbe/Babelish)[![Coverage Status](https://coveralls.io/repos/netbe/Babelish/badge.png)](https://coveralls.io/r/netbe/Babelish)
[![Gem Version](https://badge.fury.io/rb/babelish.svg)](http://badge.fury.io/rb/babelish)

**Babelish : Chaotically confused, like Babel**

Originally created to deal with localizedStrings files (aka *CSV-to-iOS-Localizable.strings-converter*), this command tool now converts a csv file of translations into the below file formats and vice-versa:
* .strings (iOS)
* .xml (Android)
* .json
* .php

It can also fetch the csv file from GoogleDrive.

# Installation

`gem install babelish`

Requires Ruby 1.9.2 or above.

# Usage

```
› babelish help
Commands:
  babelish android2csv -i, --filenames=one two three              # Convert .xml files to CSV file
  babelish csv2android --filename=FILENAME -L, --langs=key:value  # Convert CSV file to .xml
  babelish csv2json --filename=FILENAME -L, --langs=key:value     # Convert CSV file to .json
  babelish csv2php --filename=FILENAME -L, --langs=key:value      # Convert CSV file to .php
  babelish csv2strings --filename=FILENAME -L, --langs=key:value  # Convert CSV file to .strings
  babelish csv_download --gd-filename=GD_FILENAME                 # Download Google Spreadsheet containing translations
  babelish help [COMMAND]                                         # Describe available commands or one specific command
  babelish json2csv -i, --filenames=one two three                 # Convert .json files to CSV file
  babelish php2csv -i, --filenames=one two three                  # Convert .php files to CSV file
  babelish strings2csv -i, --filenames=one two three              # Convert .strings files to CSV file
  babelish version                                                # Display current version

Options:
  [--verbose], [--no-verbose]
```

You can use a **configuration file** to hold all your commandline arguments into a file.
Place a `.babelish` file (YAML) in your repo where you will run the command.
See [.babelish.sample](.babelish.sample) file in the doc folder. as the possible values.

*For previous CSV-to-iOS-Localizable.strings-converter, rename your `.csvconverter` into `.babelish`.*

# Contributing

Want to add another support for a new format or/and usage? Add a new feature? Fix a bug?

Just create a pull request with a branch like `feature/<nameofbranch>` or `hotfix/<nameofbranch>`.


## Development

Run `bundle install` to install all the dependencies. Tests are done with `Test::Unit` so run `rake test` to run all the test suite.

# Todo & Known issues

See GitHub issues
