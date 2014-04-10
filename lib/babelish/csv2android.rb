module Babelish
  class CSV2Android < Csv2Base
    require 'xmlsimple'

    attr_accessor :file_path

    def initialize(filename, langs, args = {})
      super(filename, langs, args)

      @file_path = args[:default_path].to_s
    end

    def language_filepaths(language)
      require 'pathname'
      filepath = Pathname.new(self.file_path) + "values-#{language.code}" + "strings.xml"
      return filepath ? [filepath] : []
    end

    def get_row_format(row_key, row_value)
      return "\t<string name=\"#{row_key}\">#{row_value}</string>\n"
    end

    def hash_to_output(content = {})
      output = ''
      if content && content.size > 0
        output += "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        output += "<resources>\n"
        content.each do |key, value|
          output += get_row_format(key, value)
        end
        output += "</resources>"
      end
      return output
    end
  end
end
