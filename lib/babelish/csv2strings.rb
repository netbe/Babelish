module Babelish
  class CSV2Strings < Csv2Base
    attr_accessor :languages

    def language_filepaths(language)
      require 'pathname'
      filepaths = []
      basename = filename_to_camel_case(output_basename)
      if language.regions.empty?
        filepaths << Pathname.new(@output_dir) + "#{language.code}.lproj/#{basename}.#{extension}"
      else
        language.regions.each do |region|
          filepaths << Pathname.new(@output_dir) + "#{language.code}-#{region}.lproj/#{basename}.#{extension}"
        end
      end
      filepaths
    end

    def get_row_format(row_key, row_value, comment = nil, indentation = 0)
      entry = comment.to_s.empty? ? "" : "\n/* #{comment} */\n" 
      entry + "\"#{row_key}\"" + " " * indentation + " = \"#{row_value}\";\n"
    end

    def key_to_output(key)
      row_to_camel_case(key)
    end

    def value_to_output(value)
      value.gsub "%s", "%@"
    end

    def extension
      "strings"
    end

    def output_basename
      @output_basename || 'Localizable'
    end

    def row_to_camel_case(underscope_text)
      enumerator = underscope_text.split('_').each_with_index
      enumerator.map{|word, index| index == 0 ? word : word.capitalize}.join
    end

    def filename_to_camel_case(underscope_text)
      underscope_text.split('_').map{|word| word.capitalize}.join
    end
  end
end
