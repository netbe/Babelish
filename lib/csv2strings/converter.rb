module CSV2Strings
	module Converter
	
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
							locale_dir = [CSV2StringsConfig[:path], "#{locale}.lproj"].compact.join('/')
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
end
	