# Author: Markus Paeschke <a href="mailto:markus.paeschke@gmail.com">markus.paeschke@gmail.com</a> <a href="http://www.mpaeschke.de">http://www.mpaeschke.de</a>
# 
# Converts a single or multiple android string files into a single csv file. 

module Android2CSV
  require 'xmlsimple'

  class Converter

    attr_accessor :csv_filename, :headers, :filenames, :default_lang

    def initialize(args = {:filenames => []})
      if args[:filenames] && args[:headers]
        raise ArgumentError.new("number of headers and files don't match, don't forget the constant column") unless args[:headers].size == (args[:filenames].size + 1)
      end

      @filenames = args[:filenames]

      @csv_filename = args[:csv_filename] || "translations.csv"
      @default_lang = args[:default_lang]
      @headers = args[:headers] || self.default_headers
    end

    def default_headers
      headers = ['Variables']
      @filenames.each do |fname|
        headers << basename(fname)
      end
    end

    # Load all strings of a given file
    def load_strings(strings_filename)
      strings = {}
      raise Errno::ENOENT unless File.exist?(strings_filename)
      xmlfile = XmlSimple.xml_in(strings_filename)
      xmlfile['string'].each do |element|
        strings.merge!({element['name'] => element['content']})
      end
      strings
    end

    # Convert android xml files to one CSV file
    def convert(write_to_file = true)
      strings = {}
      keys = nil
      lang_order = []

      @filenames.each do |fname|
        header = basename(fname)
        strings[header] = load_strings(fname)
        lang_order << header
        keys ||= strings[header].keys
      end

      if(write_to_file)
        # Create csv file
        puts "Creating #{@csv_filename}"
        create_csv_file(keys, lang_order, strings)
      else
        return keys, lang_order, strings
      end
    end

    def basename(file_path)
      filename = File.basename(file_path)
      return filename.split('.')[0].to_sym if file_path
    end

    # Create the resulting file
    def create_csv_file(keys, lang_order, strings)
      raise "csv_filename must not be nil" unless self.csv_filename
      CSVParserClass.open(self.csv_filename, "wb") do |csv|
        csv << @headers
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
  