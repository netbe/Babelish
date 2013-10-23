$: << File.expand_path(File.join(File.dirname(__FILE__)))
require 'rubygems'

CSVGEM = RUBY_VERSION.match(/^[0-1]\.[0-8]\./) ? 'faster_csv' : 'csv'

begin
	require CSVGEM
rescue LoadError
	puts "Failed to load #{CSVGEM} (ruby #{RUBY_VERSION})"
	puts "gem install #{CSVGEM}"
	abort
end

CSVParserClass = CSVGEM == 'csv' ? CSV : FasterCSV
require "csv2strings/converter"
require "strings2csv/converter"
