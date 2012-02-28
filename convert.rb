#!/usr/bin/env ruby

require 'rubygems'
begin
	require 'faster_csv'
rescue LoadError
	puts "FasterCSV required! i.e: gem install fastercsv"
	exit
end

module CSVStringsConverter
	# Convert Localizable.strings files to one CSV file
	def self.dotstrings_to_csv(filenames)
		newfile                                = 'Translations.csv'
		common_strings                         = {}
		headers                                = ["\"Common Constants\""]
    
		# Parse .strings files
		filenames.each do |fname|
			header = fname.split('.')[0] if fname
			headers << "\"#{header}\""
			puts "Parsing filename : #{fname}"
			FasterCSV.foreach(fname, :quote_char => '"', :col_sep =>' = ', :row_sep =>";\n") do |row|
				common_strings[row[0].to_sym] = [] unless common_strings[row[0].to_sym]
				if row.size == 2
					common_strings[row[0].to_sym] <<  row[1]
				else
					puts "dot file no well formatted"
				end
			end
		end

		# Create csv file
		puts "Create csv file"
		output = File.new(newfile, "w")
		output.write headers.join(',') + "\n"
		common_strings.each do |key, row|
			output.write "\"#{key}\",\"#{row.join('","')}\"\n"
		end
		output.close
	end  

	# Convert csv file to multiple Localizable.strings files for each column
	def self.csv_to_dotstrings(name)
		files = {}
		rowIndex = 0
		FasterCSV.foreach(name, :quote_char    => '"', :col_sep =>',', :row_sep =>:auto) do |row|
			if rowIndex == 0
				return unless row.count > 1 #check there's at least two columns
			else
				next if row == nil #skip empty lines (or sections)
			end
			row.size.times do |i|
				if rowIndex == 0 #header
					filename = "#{row[i]}.strings"
					puts ">>>Creating file : #{filename}"
					files[i] = File.new(filename,"w")
				else
					value = row[0].strip #@todo: add option to strip the constant or referenced language
					files[i].write "\"#{value}\" = \"#{row[i]}\";\n"
				end
			end
			rowIndex += 1
		end
		puts ">>>Created #{files.size} files. Content: #{rowIndex - 1} translations"
		files.each do |fileIndex,fpointer|
		  fpointer.close
		end

	end
end

# Part of the script
if $0 == __FILE__  
	# Shows help on how to use this script
	def usage
		puts "Usage:\n" #@todo: add details about arguments
		puts "ruby convert.rb <filename.csv>"
		puts "ruby convert.rb <filename1.strings> <filename2.strings>"
		exit
	end

	# Main program
	if ARGV.size < 1
		puts "Error: not enough arguments"
		usage
	elsif filename = ARGV[0] and ARGV.size == 1 and File.extname(filename).downcase == '.csv'
		CSVStringsConverter.csv_to_dotstrings(filename)
	else
		# checks arguments
		ARGV.each do |filename|
			usage if File.extname(filename).downcase != '.strings'
		end 
		CSVStringsConverter.dotstrings_to_csv(ARGV)
	end
end