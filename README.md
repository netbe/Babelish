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

Requires Ruby 1.9.3 or above.

Or download [Latest Release](https://github.com/netbe/Babelish/releases/latest).

# Usage

```
› babelish help
Commands:
  babelish android2csv     # Convert .xml files to CSV file
  babelish csv2android     # Convert CSV file to .xml
  babelish csv2json        # Convert CSV file to .json
  babelish csv2php         # Convert CSV file to .php
  babelish csv2strings     # Convert CSV file to .strings
  babelish csv_download    # Download Google Spreadsheet containing translations
  babelish help [COMMAND]  # Describe available commands or one specific command
  babelish json2csv        # Convert .json files to CSV file
  babelish open FILE       # Open local csv file in default editor or Google Spreadsheet containing translations in default browser
  babelish php2csv         # Convert .php files to CSV file
  babelish strings2csv     # Convert .strings files to CSV file
  babelish version         # Display current version
Options:
  [--verbose], [--no-verbose]
```

You can use a **configuration file** to hold all your commandline arguments into a file.
Place a `.babelish` file (YAML) in your repo where you will run the command. In case you need to reset the Google Drive token you have to delete the .babelish.token file.
See [.babelish.sample](.babelish.sample) file in the doc folder. as the possible values.

*For previous CSV-to-iOS-Localizable.strings-converter, rename your `.csvconverter` into `.babelish`.*

**For more details, check the documentation:**
https://github.com/netbe/Babelish/wiki/How-to-Use

# Contributing

Want to add another support for a new format or/and usage? Add a new feature? Fix a bug?

Just create a pull request with a branch like `feature/<nameofbranch>` or `hotfix/<nameofbranch>`.


## Development

Run `bundle install` to install all the dependencies. Tests are done with `Test::Unit` so run `rake test` to run all the test suite.

# Todo & Known issues

See GitHub issues
