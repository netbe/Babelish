module Babelish
  class CSV2Strings < Csv2Base
    attr_accessor :languages

    def language_filepaths(language)
      require 'pathname'
      filepaths = []
      if language.regions.empty?
        filepaths << Pathname.new(@output_dir) + "#{language.code}.lproj/#{output_basename}.#{extension}"
      else
        language.regions.each do |region|
          filepaths << Pathname.new(@output_dir) + "#{language.code}-#{region}.lproj/#{output_basename}.#{extension}"
        end
      end
      filepaths
    end

    def get_row_format(row_key, row_value, comment = nil, indentation = 0)
      entry = comment.to_s.empty? ? "" : "\n/* #{comment} */\n" 
      entry + "\"#{row_key}\"" + " " * indentation + " = \"#{row_value}\";\n"
    end

    def extension
      "strings"
    end

    def output_basename
      @output_basename || 'Localizable'
    end
  end
end
