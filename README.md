[![Build Status](https://secure.travis-ci.org/netbe/CSV-to-iOS-Localizable.strings-converter.png?branch=master)](http://travis-ci.org/netbe/CSV-to-iOS-Localizable.strings-converter)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/netbe/CSV-to-iOS-Localizable.strings-converter)
[![Coverage Status](https://coveralls.io/repos/netbe/CSV-to-iOS-Localizable.strings-converter/badge.png)](https://coveralls.io/r/netbe/CSV-to-iOS-Localizable.strings-converter)
# Introduction
This script converts a csv file of translations into iOS .strings files and vice-versa.

# Setup

`gem install csv2strings`

# Usage

* Convert csv to localizable strings files:

`csv2strings <csvfilename>`

* Convert localizable strings files to csv:

`strings2csv <stringsfile1> <stringsfile2>`

* Use configuration file

You can use a configuration file to hold all your commandline arguments into a file (previous versions `i18n_config.rb`).
Place `.csvconverter` file (edit if needed) in the folder with your ``xx.lproj`` and call the script from there. See `.csvconverter.sample`

# Contributing

If you feel like it, just create a pull request with a branch like `feature/<nameofbranch>` to `develop` branch


## Development

Edge version can be found on `develop` branch.

Run `bundle install` to install all the dependencies. Tests are done with `Test::Unit` so run `rake test` to run all the test suite.

# Todo & Known issues

See GitHub issues
