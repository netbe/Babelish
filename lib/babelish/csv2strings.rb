module Babelish
  class CSV2Strings < Csv2Base
    attr_accessor :file_path

    def initialize(filename, langs, args = {})
      super(filename, langs, args)

      @file_path = args[:default_path].to_s
    end

    def language_filepaths(language)
      require 'pathname'
      filepaths = []

      if language.regions.empty?
        filepaths << Pathname.new(self.file_path) + "#{language.code}.lproj/Localizable.strings"
      else
        language.regions.each do |region|
          filepaths << Pathname.new(self.file_path) + "#{language.code}-#{region}.lproj/Localizable.strings"
        end
      end
      filepaths
    end

    def get_row_format(row_key, row_value)
      return "\"#{row_key}\" = \"#{row_value}\";\n"
    end

  end
end
