class Strings2CSV
  # default_lang is the the column to refer to if a value is missing
  # actually default_lang = default_filename
  attr_accessor :csv_filename, :headers, :filenames, :default_lang

  def initialize(args = {:filenames => []})
    raise ArgumentError.new("No filenames given") unless args[:filenames]
    if args[:headers]
      raise ArgumentError.new("number of headers and files don't match, don't forget the constant column") unless args[:headers].size == (args[:filenames].size + 1)
    end

    @filenames = args[:filenames]

    @csv_filename = args[:csv_filename] || "translations.csv"
    @default_lang = args[:default_lang]
    @headers = args[:headers] || self.default_headers
  end

  def default_headers
    headers = ["Variables"]
    @filenames.each do |fname|
      headers << fname
    end
    headers
  end


  # Load all strings of a given file
  def load_strings(strings_filename)
    strings = ORDERED_HASH_CLASS.new
    File.open(strings_filename, 'r') do |strings_file|
      strings_file.read.each_line do |line|
        hash = self.parse_dotstrings_line(line)
        strings.merge!(hash) if hash
      end
    end
    strings
  end

  def parse_dotstrings_line(line)
    line.strip!
    if (line[0] != ?# and line[0] != ?=)
      m = line.match(/^[^\"]*\"(.+)\"[^=]+=[^\"]*\"(.*)\";/)
      return {m[1] => m[2]} unless m.nil?
    end
  end


  # Convert Localizable.strings files to one CSV file
  # output: strings hash has filename for keys and the content of csv
  def dotstrings_to_csv(write_to_file = true)
    # Parse .strings files
    strings = {}
    keys = nil
    lang_order = []

    @filenames.each do |fname|
      header = fname
      strings[header] = load_strings(fname)
      keys ||= strings[header].keys
    end

    if(write_to_file)
      # Create csv file
      puts "Creating #{@csv_filename}"
      create_csv_file(keys, strings)
    else
      return keys, strings
    end
  end

  def basename(file_path)
    filename = File.basename(file_path)
    return filename.split('.')[0].to_sym if file_path
  end

  # Create the resulting file
  def create_csv_file(keys, strings)
    raise "csv_filename must not be nil" unless self.csv_filename
    CSVParserClass.open(self.csv_filename, "wb") do |csv|
      csv << @headers
      keys.each do |key|
        line = [key]
        default_val = strings[self.default_lang][key] if strings[self.default_lang]
        @filenames.each do |fname|
          lang = fname
          current_val = strings[lang][key]
          line << ((lang != self.default_lang and current_val == default_val) ? '' : current_val)
        end
        csv << line
      end
      puts "Done"
    end
  end

end
