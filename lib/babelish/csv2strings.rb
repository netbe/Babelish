module Babelish
  class CSV2Strings < Csv2Base

    def language_filepaths(language)
      require 'pathname'
      filepaths = []
      filename = @output_basename || 'Localizable'

      if language.regions.empty?
        filepaths << Pathname.new(@output_dir) + "#{language.code}.lproj/#{filename}.strings"
      else
        language.regions.each do |region|
          filepaths << Pathname.new(@output_dir) + "#{language.code}-#{region}.lproj/#{filename}.strings"
        end
      end
      filepaths
    end

    def get_row_format(row_key, row_value)
      return "\"#{row_key}\" = \"#{row_value}\";\n"
    end

    def extension
      "strings"
    end
  end
end
