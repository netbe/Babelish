require 'csv'
CSVParserClass = CSV

# Fixes UTF8 issues
# see http://stackoverflow.com/questions/4583924/string-force-encoding-in-ruby-1-8-7-or-rails-2-x
class String
  def to_utf8
  	force_encoding("UTF-8")
  end
end


# From CSV
require "babelish/csv2base"
require "babelish/csv2strings"
require "babelish/csv2android"
require "babelish/csv2php"
require "babelish/csv2json"

# To CSV
require "babelish/base2csv"
require "babelish/strings2csv"
require "babelish/android2csv"
require "babelish/php2csv"
require "babelish/json2csv"

# General
require "babelish/language"
require "babelish/google_doc"
