module Babelish
  require 'json'
  class CSV2JSON < Csv2Base

    def initialize(filename, langs, args = {})
      super
      @pretty_json = args[:pretty_json]
    end

    def language_filepaths(language)
      require 'pathname'
      filename = @output_basename || language.code
      filepath = Pathname.new("#{@output_dir}#{filename}.#{extension}")

      return filepath ? [filepath] : []
    end

    def hash_to_output(content = {})
      return @pretty_json ? JSON.pretty_generate(content) : content.to_json
    end

    def extension
      "json"
    end
  end
end
