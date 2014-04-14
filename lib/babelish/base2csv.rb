module Babelish
  class Base2Csv
    attr_accessor :csv_filename, :headers, :filenames, :default_lang

    def initialize(args = {:filenames => []})
      raise ArgumentError.new("No filenames given") unless args[:filenames]
      if args[:headers]
        raise ArgumentError.new("number of headers and files don't match, don't forget the constant column") unless args[:headers].size == (args[:filenames].size + 1)
      end

      @filenames = args[:filenames]

      @csv_filename = args[:csv_filename] || "translations.csv"
      @default_lang = args[:default_lang]
      @headers = args[:headers] || default_headers
    end

    public

    # Process files and create csv
    #
    # @param [Boolean] write_to_file create or not the csv file
    # @return [Hash] the translations formatted if write_to_file
    def convert(write_to_file = true)
      strings = {}
      keys = nil

      @filenames.each do |fname|
        header = fname
        strings[header] = load_strings(fname)
        keys ||= strings[header].keys
      end

      if write_to_file
        # Create csv file
        puts "Creating #{@csv_filename}"
        create_csv_file(keys, strings)
      else
        return keys, strings
      end
    end

    protected

    # Load all strings of a given file
    #
    # @param [String, #read] strings_filename filename of file containing translations
    # for a given language
    # @return [Hash] the translations for a given language
    def load_strings(strings_filename)
      return {}
    end

    # Give the default headers of csv file
    #
    # @return [Array] headers of csv
    def default_headers
      headers = ["Variables"]
      @filenames.each do |fname|
        headers << fname
      end
      headers
    end

    # Basename of given file
    #
    # @param [String, #read] file_path
    # @return [String] basename
    def basename(file_path)
      filename = File.basename(file_path)
      return filename.split('.')[0].to_sym if file_path
    end

    private

    # Create the resulting file
    #
    # @param [Array] keys references of all translations
    # @param [Array] strings translations of all languages
    def create_csv_file(keys, strings)
      raise "csv_filename must not be nil" unless @csv_filename
      CSV.open(@csv_filename, "wb") do |csv|
        csv << @headers
        keys.each do |key|
          line = [key]
          default_val = strings[@default_lang][key] if strings[@default_lang]
          @filenames.each do |fname|
            lang = fname
            current_val = (lang != default_lang && strings[lang][key] == default_val) ? '' : strings[lang][key]
            line << current_val
          end
          csv << line
        end
        puts "Done"
      end
    end
  end
end
