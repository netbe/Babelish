$: << File.expand_path(File.join(File.dirname(__FILE__)))
require 'rubygems'

# loads the modules from the lib folder dynamically
def loadLibraries
	libraries = Dir.glob(File.expand_path(File.join(File.dirname(__FILE__))) + '/*').select{|folder| File.directory? folder.to_s}
	libraries.each do |folder|
	    if Dir.glob(folder + '/converter.rb').size > 0
	        require folder.to_s + "/converter"
	    end
	end
end

CSVGEM = RUBY_VERSION.match(/^[0-1]\.[0-8]\./) ? 'faster_csv' : 'csv'

begin
	require CSVGEM
rescue LoadError
	puts "Failed to load #{CSVGEM} (ruby #{RUBY_VERSION})"
	puts "gem install #{CSVGEM}"
	exit
end

CSVParserClass = CSVGEM == 'csv' ? CSV : FasterCSV
loadLibraries