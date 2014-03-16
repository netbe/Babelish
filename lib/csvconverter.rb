CSVGEM = RUBY_VERSION.match(/^[0-1]\.[0-8]\./) ? 'faster_csv' : 'csv'

if RUBY_VERSION.match(/^[0-1]\.[0-8]\./)
  require "orderedhash"
  ORDERED_HASH_CLASS = OrderedHash
else
  ORDERED_HASH_CLASS = Hash
end

begin
	require CSVGEM
rescue LoadError
	puts "Failed to load #{CSVGEM} (ruby #{RUBY_VERSION})"
	puts "gem install #{CSVGEM}"
	abort
end

CSVParserClass = CSVGEM == 'csv' ? CSV : FasterCSV


# Fixes UTF8 issues
# see http://stackoverflow.com/questions/4583924/string-force-encoding-in-ruby-1-8-7-or-rails-2-x
if RUBY_VERSION.match(/^[0-1]\.[0-8]\./)
	require 'iconv'
	class String
	  def to_utf8
	    ::Iconv.conv('UTF-8//IGNORE', 'UTF-8', self + ' ')[0..-2]
	  end
	end
else
	class String
	  def to_utf8
	  	force_encoding("UTF-8")
	  end
	end
end

# From CSV
require "csvconverter/csv2base"
require "csvconverter/csv2strings"
require "csvconverter/csv2android"
require "csvconverter/csv2php"
require "csvconverter/csv2json"

# To CSV
require "csvconverter/base2csv"
require "csvconverter/strings2csv"
require "csvconverter/android2csv"
require "csvconverter/php2csv"
require "csvconverter/json2csv"

# General
require "csvconverter/language"
require "csvconverter/google_doc"
