module Babelish
  class CSV2Android < Csv2Base
    attr_accessor :file_path

    def initialize(filename, langs, args = {})
      super(filename, langs, args)

      @file_path = args[:output_dir].to_s
      @output_basename = args[:output_basename].to_s
    end

    def language_filepaths(language)
      require 'pathname'
      output_name = "strings.xml"
      output_name = "#{@output_basename}.xml" unless @output_basename.empty?
      region = language.region.to_s.empty? ? "" : "-r#{language.region}"
      filepath = Pathname.new(@file_path) + "values-#{language.code}#{region}" + output_name
      return filepath ? [filepath] : []
    end

    def process_value(row_value, default_value)
      value = super(row_value, default_value)
      value.gsub!(/'/, "'" => "\\'") # escape single quote only for Android
      # if the value begins and ends with a quote we must leave them unescaped
      if value.size > 4 && value[0, 2] == "\\\"" && value[value.size - 2, value.size] == "\\\""
        value[0, 2] = "\""
        value[value.size - 2, value.size] = "\""
      end
      value.to_utf8
    end

    def get_row_format(row_key, row_value, comment = nil, indentation = 0)
      entry = comment.to_s.empty? ? "" : "\n\t<!-- #{comment} -->\n"
      entry + "\t<string name=\"#{row_key}\">#{row_value}</string>\n"
    end

    def hash_to_output(content = {})
      output = ''
      if content && content.size > 0
        output += "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
        output += "<resources>\n"
        content.each do |key, value|
          comment = @comments[key]
          output += get_row_format(key, value, comment)
        end
        output += "</resources>\n"
      end
      return output
    end

    def extension
      "xml"
    end
  end
end
