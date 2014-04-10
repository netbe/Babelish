require 'charlock_holmes'
class Strings2CSV < Base2Csv
  # default_lang is the the column to refer to if a value is missing
  # actually default_lang = default_filename
  attr_accessor :csv_filename, :headers, :filenames, :default_lang

    def initialize(args = {:filenames => []})
        super(args)
    end

    def parse_dotstrings_line(line)
        line.strip!
        if (line[0] != ?# and line[0] != ?=)
            m = line.match(/^[^\"]*\"(.+)\"[^=]+=[^\"]*\"(.*)\";/)
            return {m[1] => m[2]} unless m.nil?
        end
    end

  # Load all strings of a given file
  def load_strings(strings_filename)
    strings = ORDERED_HASH_CLASS.new

    # Make sure we use correct encoding
    contents = File.open(strings_filename).read
    detection = CharlockHolmes::EncodingDetector.detect(contents)
    utf8_encoded_content = CharlockHolmes::Converter.convert contents, detection[:encoding], 'UTF-8'

    utf8_encoded_content.each_line do |line|
      hash = self.parse_dotstrings_line(line)
      strings.merge!(hash) if hash
    end

    strings
  end

end
