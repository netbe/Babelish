[![Build Status](https://secure.travis-ci.org/netbe/Babelish.png?branch=master)](http://travis-ci.org/netbe/Babelish)
[![Code Climate](https://codeclimate.com/github/netbe/Babelish.png)](https://codeclimate.com/github/netbe/Babelish)[![Coverage Status](https://coveralls.io/repos/netbe/Babelish/badge.png)](https://coveralls.io/r/netbe/Babelish)
[![Gem Version](https://badge.fury.io/rb/babelish.svg)](http://badge.fury.io/rb/babelish)
# Introduction
This script converts a csv file of translations into the below file formats and vice-versa:
* .strings (iOS)
* .xml (Android)
* .json
* .php

# Requirements

* Ruby 1.9.2 or above

# Setup

`gem install babelish`

# Usage

` babelish help`

* Use configuration file

You can use a configuration file to hold all your commandline arguments into a file.
Place a `.babelish` file (YAML) in your repo where you will run the command.
See [.babelish.sample](.babelish.sample) file in the doc folder. as the possible values.

# Contributing

Want to add another support for a new format or/and usage? Add a new feature? Fix a bug?

Just create a pull request with a branch like `feature/<nameofbranch>` or `hotfix/<nameofbranch>`.


## Development

Edge version can be found on `develop` branch.

Run `bundle install` to install all the dependencies. Tests are done with `Test::Unit` so run `rake test` to run all the test suite.

# Todo & Known issues

See GitHub issues
