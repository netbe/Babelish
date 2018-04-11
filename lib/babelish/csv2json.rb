module Babelish
  require 'json'
  class CSV2JSON < Csv2Base

    def language_filepaths(language)
      require 'pathname'
      filename = @output_basename || language.code
      filepath = Pathname.new("#{@output_dir}/#{filename}.#{language.code}.#{extension}")

      return filepath ? [filepath] : []
    end

    def hash_to_output(content = {})
      return content.to_json
    end

    def extension
      "json"
    end
  end
end
