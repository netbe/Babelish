module CSV2Strings
	class Converter
		attr_accessor :csv_filename, :output_file

		def initialize(filename, args = {})
			@csv_filename = filename
			if self.class.langs.size == 0
				@output_file = args[:output_file]
			else
				@output_file = nil
			end
		end

		def csv_to_dotstrings
			self.class.csv_to_dotstrings(self.csv_filename)
		end
		
		def self.excluded_states
			return CSV2StringsConfig[:excluded_states] if defined?(CSV2StringsConfig)
			[]
		end
		
		def self.state_column
			return CSV2StringsConfig[:state_column] if defined?(CSV2StringsConfig)
			10  
		end

		def self.keys_column
			return CSV2StringsConfig[:keys_column] if defined?(CSV2StringsConfig)
			0
		end

		def self.default_lang
			return CSV2StringsConfig[:default_lang] if defined?(CSV2StringsConfig)
			'English' 
		end

		def self.langs
			return CSV2StringsConfig[:langs] if defined?(CSV2StringsConfig)
			{'English'  => [:en]}
		end

		def self.default_path
			return CSV2StringsConfig[:path] if defined?(CSV2StringsConfig)
			""
		end

		def self.create_file_from_path(file_path)
			path = File.dirname(file_path)
			# filename = File.basename(file_path)
			FileUtils.mkdir_p path
			return File.new(file_path,"w")
		end

		def self.process_header(excludedCols, defaultCol, files, row, index)
			defaultCol = index if self.default_lang == row[index]
			files[index]   = []
			puts self.langs
			lang_index = row[index]

			# create output files here
			if @output_file
				# one single file
				files[index] << self.create_file_from_path(@output_file)
			else
				# create one file for each languages
				self.langs[lang_index].each do |locale|
					# get file_path for locale
					filename = self.file_path_for_locale(locale)
					files[index] << self.create_file_from_path(filename)
				end
			end
		end

		def self.file_path_for_locale(locale)
			require 'pathname' 
			Pathname.new(self.default_path) + "#{locale}.lproj" + "Localizable.strings"
		end
		
		def self.process_value(row_value, default_value)
			value = row_value.nil? ? default_value : row_value
			value = "" if value.nil?
			value.gsub!(/\\*\"/, "\\\"") #escape double quotes
			value.gsub!(/\s*(\n|\\\s*n)\s*/, "\\n") #replace new lines with \n + strip
			value.gsub!(/%\s+([a-zA-Z@])([^a-zA-Z@]|$)/, "%\\1\\2") #repair string formats ("% d points" etc)
			value.gsub!(/([^0-9\s\(\{\[^])%/, "\\1 %")
			value.strip!
			return value
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
					next if row == nil or row[self.keys_column].nil? #skip empty lines (or sections)
				end
				row.size.times do |i|
					next if excludedCols.include? i
					if rowIndex == 0 #header
						excludedCols << i and next unless self.langs.has_key?(row[i])
						self.process_header(excludedCols, defaultCol, files, row, i)
					elsif row[self.state_column].nil? or row[self.state_column] == '' or !self.excluded_states.include? row[self.state_column]
						# TODO: add option to strip the constant or referenced language
						key = row[self.keys_column].strip 
						value = self.process_value(row[i], row[defaultCol])
						files[i].each do |file|
							file.write "\"#{key}\" = \"#{value}\";\n"
						end
					end
					rowIndex += 1
				end
			end
			puts ">>>Created #{files.size} files. Content: #{rowIndex - 1} translations"

			# closing I/O
			files.each do |key,locale_files|
				locale_files.each do |file|
					file.close
				end
			end

		end # end of method

	end # end of class
end
	