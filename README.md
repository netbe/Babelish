[![Build Status](https://secure.travis-ci.org/netbe/CSV-to-iOS-Localizable.strings-converter.png?branch=master)](http://travis-ci.org/netbe/CSV-to-iOS-Localizable.strings-converter)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/netbe/CSV-to-iOS-Localizable.strings-converter)
[![Coverage Status](https://coveralls.io/repos/netbe/CSV-to-iOS-Localizable.strings-converter/badge.png)](https://coveralls.io/r/netbe/CSV-to-iOS-Localizable.strings-converter)
[![Gem Version](https://badge.fury.io/rb/csv2strings.png)](http://badge.fury.io/rb/csv2strings)
# Introduction
This script converts a csv file of translations into the below file formats and vice-versa:
* .strings (iOS)
* .xml (Android)
* .json
* .php

# Requirements

* Ruby 1.9.2 or above
* Needs [ICU](http://site.icu-project.org/). Via `brew install icu4c` on Mac or `apt-get install libicu-dev` on Linux

# Setup

`gem install babelish`

# Usage

` babelish help`

* Use configuration file

You can use a configuration file to hold all your commandline arguments into a file.
Place a `.babelish` file in your repo where you will run the command.
See `.babelish.sample` as the possible values.

# Contributing

If you feel like it, just create a pull request with a branch like `feature/<nameofbranch>` to `develop` branch


## Development

Edge version can be found on `develop` branch.

Run `bundle install` to install all the dependencies. Tests are done with `Test::Unit` so run `rake test` to run all the test suite.

# Todo & Known issues

See GitHub issues
