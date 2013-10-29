CSVGEM = RUBY_VERSION.match(/^[0-1]\.[0-8]\./) ? 'faster_csv' : 'csv'

# if RUBY_VERSION.match(/^[0-1]\.[0-8]\./)
#   require "orderedhash"
#   ORDERED_HASH_CLASS = OrderedHash
# else
#   ORDERED_HASH_CLASS = Hash
# end

begin
	require CSVGEM
rescue LoadError
	puts "Failed to load #{CSVGEM} (ruby #{RUBY_VERSION})"
	puts "gem install #{CSVGEM}"
	abort
end

CSVParserClass = CSVGEM == 'csv' ? CSV : FasterCSV
require "csvconverter/csv2strings"
require "csvconverter/strings2csv"
require "csvconverter/google_doc"

# commands
require "csvconverter/commands/strings2csv_command"
require "csvconverter/commands/csv2strings_command"
