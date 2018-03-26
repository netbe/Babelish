module Babelish
  # Converter from csv format to Rails like yaml format
  class CSV2YAML < Csv2Base
    attr_accessor :is_first_row
    attr_accessor :deep

    def initialize(filename, langs, args = {})
      super(filename, langs, args)
      @is_first_row = true
      @deep = 1
    end

    def language_filepaths(language)
      require 'pathname'
      filename = @output_basename || language.code
      filepath = Pathname.new("#{@output_dir}/#{filename}.#{language.code}.#{extension}")
      @language = language
      filepath ? [filepath] : []
    end

    def get_row_format(row_key, row_value, comment = nil, indentation = 0)
      entry = ''
      indent = '  '
      if @is_first_row
        entry << "#{@language.code}:\n"
        @deep = 1
        unless @output_basename.empty?
          entry << "#{indent}#{@output_basename}:\n"
          @deep = 2
        end
        @is_first_row = false
      end
      entry << "#{indent*@deep}# #{comment}\n" unless comment.to_s.empty?
      entry << "#{indent*@deep}#{row_key}: \"#{row_value}\"\n"
    end

    def extension
      'yaml'
    end

  end
end
