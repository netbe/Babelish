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

# From CSV
require "csvconverter/csv2base"
require "csvconverter/csv2strings"
require "csvconverter/csv2android"

# To CSV
require "csvconverter/base2csv"
require "csvconverter/strings2csv"
require "csvconverter/android2csv"

# General
require "csvconverter/language"
require "csvconverter/google_doc"

