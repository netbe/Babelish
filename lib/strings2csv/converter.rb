module Strings2CSV
  class Converter

    attr_accessor :csv_filename, :headers, :filenames

    def initialize(args={})
      @csv_filename = args[:csv_filename]
      @headers ||= args[:headers]
      @filenames ||= args[:filenames]
    end

    # TODO replace these methods to instance variables
    def default_lang 
      return Strings2CSVConfig[:default_lang] if defined?(Strings2CSVConfig)
      "default_lang"
    end
    # def csv_filename
    #   return Strings2CSVConfig[:output_file] if defined?(Strings2CSVConfig)
      
    # end

    # Get the first column name (reference) for CSV file
    def default_header
      return Strings2CSVConfig[:keys_column] if defined?(Strings2CSVConfig)
      # name of the first given file
      'Variables'
    end

    # Get the Column name of CSV file
    # Default: name of file
    # i.e. : en, fr, ...
    def self.column_name(basename)
      return Strings2CSVConfig[:langs][basename].to_s if defined?(Strings2CSVConfig)     
      # name of the first given file
      basename.to_s
    end

    # Retrieve ".strings" location path of Xcode project
    def self.get_locale_paths
      paths = []
      Strings2CSVConfig[:langs].each do |locale,lang_name|
        paths << "#{locale}.lproj/Localizable.strings"
      end
      paths
    end

    # Load all strings of a given file
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

   
    # Convert Localizable.strings files to one CSV file
    def self.dotstrings_to_csv(filenames)
      filenames ||= self.get_locale_paths

      # Parse .strings files
      strings = {}
      keys = nil
      headers = [self.default_header]
      lang_order = []
      filenames.each do |fname|
        header = fname.split('.')[0].to_sym if fname
        puts "Parsing filename : #{fname}"
        strings[header] = self.load_strings(fname)
        lang_order << header
        puts self.column_name(header)
        headers << self.column_name(header)
        puts headers.inspect
        puts lang_order.inspect
        keys ||= strings[header].keys
      end

      # Create csv file
      puts "Creating #{self.csv_filename}"
      self.create_csv_file(headers, keys, lang_order, strings)
    end

    # Create the resulting file
    def self.create_csv_file(headers, keys, lang_order, strings)
      CSVParserClass.open(self.csv_filename, "wb") do |csv|
        csv << headers
        keys.each do |key|
          line = [key]
          default_val = strings[self.default_lang][key] if strings[self.default_lang]
          lang_order.each do |lang|
            current_val = strings[lang][key]
            line << ((lang != self.default_lang and current_val == default_val) ? '' : current_val)
          end
          csv << line
        end
        puts "Done"
      end
    end

  end
end
  