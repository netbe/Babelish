module Babelish
  # Converter from csv format to Rails like yaml format
  class CSV2YAML < Csv2Base
    attr_accessor :is_first_row

    def initialize(filename, langs, args = {})
      super(filename, langs, args)
      @is_first_row = true
    end

    def language_filepaths(language)
      require 'pathname'
      filename = @output_basename || language.code
      filepath = Pathname.new("#{@output_dir}/#{filename}.#{extension}")
      @language = language
      filepath ? [filepath] : []
    end

    def get_row_format(row_key, row_value, comment = nil, _indentation = 0)
      entry = ''
      if @is_first_row
        entry += "#{@language.code}:\n"
        @is_first_row = false
      end
      indent = '  '
      entry << "#{indent}# #{comment}\n" unless comment.to_s.empty?
      entry << "#{indent}#{row_key}: \"#{row_value}\"\n"
    end

    def extension
      'yaml'
    end
  end
end
