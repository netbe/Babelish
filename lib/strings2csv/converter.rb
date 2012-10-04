module Strings2CSV
  module Converter
  
    def self.load_strings(strings_filename)
      strings = {}
      File.open(strings_filename, 'r') do |strings_file|
        strings_file.read.each_line do |line|     
          strings.merge!(self.parse_dotstrings_line(line))
        end
      end
      strings
    end
    
    def self.parse_dotstrings_line(line)
      line.strip!
      if (line[0] != ?# and line[0] != ?=)
        m = line.match(/^[^\"]*\"(.+)\"[^=]+=[^\"]*\"(.*)\";/)
        return {m[1] => m[2]} unless m.nil?
      end
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

  end
end
  