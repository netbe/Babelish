#!/usr/bin/env ruby

require 'rubygems'

CSVGEM = RUBY_VERSION.match(/^[0-1]\.[0-8]\./) ? 'faster_csv' : 'csv'

begin
	require CSVGEM
rescue LoadError
	puts "Failed to load #{CSVGEM} (ruby #{RUBY_VERSION})"
	puts "gem install #{CSVGEM}"
	exit
end

CSVParserClass = CSVGEM == 'csv' ? CSV : FasterCSV

begin
	load 'i18n_config.rb'
rescue
	puts "Failed to load i18n_config.rb"
	puts "Put i18n_config.rb in current directory"
	exit
end

module CSVStringsConverter
	def self.load_strings(strings_filename)
		strings = {}
		File.open(strings_filename, 'r') do |strings_file|
			strings_file.read.each_line do |line|
				line.strip!
				if (line[0] != ?# and line[0] != ?=)
					m = line.match(/^[^\"]*\"(.+)\"[^=]+=[^\"]*\"(.*)\";/)
					unless m.nil?
						strings[m[1]] = m[2]
					end
				end
			end
		end
		strings
	end

	def self.get_locale_paths
		paths = []
		Strings2CSVConfig[:langs].each do |locale,lang_name|
			paths << "#{locale}.lproj/Localizable.strings"
		end
		paths
	end
	# Convert Localizable.strings files to one CSV file
	def self.dotstrings_to_csv(filenames)
		filenames ||= self.get_locale_paths

		# Parse .strings files
		strings = {}
		keys = nil
		headers = [Strings2CSVConfig[:keys_column]]
		lang_order = []
		filenames.each do |fname|
			header = fname.split('.')[0].to_sym if fname
			puts "Parsing filename : #{fname}"
			strings[header] = self.load_strings(fname)
			lang_order << header
			headers << Strings2CSVConfig[:langs][header].to_s
			keys ||= strings[header].keys
		end

		# Create csv file
		puts "Creating #{Strings2CSVConfig[:output_file]}"
		CSVParserClass.open(Strings2CSVConfig[:output_file], "wb") do |csv|
			csv << headers
			keys.each do |key|
				line = [key]
				default_val = strings[Strings2CSVConfig[:default_lang]][key]
				lang_order.each do |lang|
					current_val = strings[lang][key]
					line << ((lang != Strings2CSVConfig[:default_lang] and current_val == default_val) ? '' : current_val)
				end
				csv << line
			end
			puts "Done"
		end
	end

	# Convert csv file to multiple Localizable.strings files for each column
	def self.csv_to_dotstrings(name)
		files        = {}
		rowIndex     = 0
		excludedCols = []
		defaultCol   = 0
		CSVParserClass.foreach(name, :quote_char => '"', :col_sep =>',', :row_sep => :auto) do |row|
			if rowIndex == 0
				return unless row.count > 1 #check there's at least two columns
			else
				next if row == nil or row[CSV2StringsConfig[:keys_column]].nil? #skip empty lines (or sections)
			end
			row.size.times do |i|
				next if excludedCols.include? i
				if rowIndex == 0 #header
					excludedCols << i and next unless CSV2StringsConfig[:langs].has_key?(row[i])
					defaultCol = i if CSV2StringsConfig[:default_lang] == row[i]
					files[i]   = []
					CSV2StringsConfig[:langs][row[i]].each do |locale|
						locale_dir = "#{locale}.lproj"
						unless FileTest::directory?(locale_dir)
							Dir::mkdir(locale_dir)
						end
						filename = "#{locale_dir}/Localizable.strings"
						puts ">>>Creating file : #{filename}"
						files[i] << File.new(filename,"w")
					end
				elsif row[CSV2StringsConfig[:state_column]].nil? or row[CSV2StringsConfig[:state_column]] == '' or !CSV2StringsConfig[:excluded_states].include? row[CSV2StringsConfig[:state_column]]
					key = row[CSV2StringsConfig[:keys_column]].strip #@todo: add option to strip the constant or referenced language
					value = row[i].nil? ? row[defaultCol] : row[i]
          value = "" if value.nil?
					value.gsub!(/\\*\"/, "\\\"") #escape double quotes
					value.gsub!(/\s*(\n|\\\s*n)\s*/, "\\n") #replace new lines with \n + strip
					value.gsub!(/%\s+([a-zA-Z@])([^a-zA-Z@]|$)/, "%\\1\\2") #repair string formats ("% d points" etc)
					value.gsub!(/([^0-9\s\(\{\[^])%/, "\\1 %")
					value.strip!
					files[i].each do |file|
						file.write "\"#{key}\" = \"#{value}\";\n"
					end
				end
			end
			rowIndex += 1
		end
		puts ">>>Created #{files.size} files. Content: #{rowIndex - 1} translations"
		files.each do |key,locale_files|
			locale_files.each do |file|
				file.close
			 end
		end

	end
end

# Part of the script
if $0 == __FILE__
	# Shows help on how to use this script
	def usage
		puts "Usage:\n" #@todo: add details about arguments
		puts "Strings 2 CSV : make CSV with xx.lproj/Localizable.strings files in current directory"
		puts "    ./convert.rb\n\n"
		puts "Strings 2 CSV : make CSV with custom .strings file list"
		puts "    ./convert.rb <filename1.strings> [...]\n\n"
		puts "CSV 2 Strings : make xx.lproj/Localizable.strings files (in cwd) with CSV file"
		puts "    ./convert.rb <filename.csv>\n\n"
		exit
	end

	# Main program
	if ARGV.size < 1
		CSVStringsConverter.dotstrings_to_csv(nil)
		#puts "Error: not enough arguments"
		#usage
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