[![Build Status](https://secure.travis-ci.org/netbe/CSV-to-iOS-Localizable.strings-converter.png?branch=master)](http://travis-ci.org/netbe/CSV-to-iOS-Localizable.strings-converter)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/netbe/CSV-to-iOS-Localizable.strings-converter)
# Introduction
This script converts a csv file of translations into iOS .strings files and vice-versa.

# Setup

For rubygems version: `gem install csv2strings`

For dev version with Gdrive support:

```
gem "csv2strings", :git => "https://github.com/netbe/CSV-to-iOS-Localizable.strings-converter", :branch => "develop"
```

# Usage

* Convert csv to localizable strings files:

`csv2strings <csvfilename>`

* Convert localizable strings files to csv:

`strings2csv <stringsfile1> <stringsfile2>`

* Use configuration file

You can use a configuration file to hold all your commandline arguments into a file (previous versions `i18n_config.rb`).
Place `.csvconverter` file (edit if needed) in the folder with your ``xx.lproj`` and call the script from there. See `.csvconverter.sample`


# Todo

See GitHub isssues

# Known issues

* Gdrive support does not work on 1.8.7
