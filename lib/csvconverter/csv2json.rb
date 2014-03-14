require 'json'
class CSV2JSON < Csv2Base
    attr_accessor :file_path

    def initialize(filename, langs, args = {})
        super(filename, langs, args)

        @file_path = args[:default_path].to_s
    end

    def language_filepaths(language)
        require 'pathname'
        filepath = Pathname.new("#{self.file_path}#{language.code}.js")
        return filepath ? [filepath] : []
    end

    def hash_to_output(content = {})
        return content.to_json
    end
end
