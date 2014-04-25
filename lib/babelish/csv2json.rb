module Babelish
  require 'json'
  class CSV2JSON < Csv2Base

    def language_filepaths(language)
      require 'pathname'
      filename = @output_basename || language.code
      filepath = Pathname.new("#{@output_dir}#{filename}.js")

      return filepath ? [filepath] : []
    end

    def hash_to_output(content = {})
      return content.to_json
    end

    def extension
      "js"
    end
  end
end
