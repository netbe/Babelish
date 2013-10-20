module CSV2JSON
    require File.expand_path('../../csv2base', __FILE__)
    require 'json'

    class Converter < Csv2Base
        attr_accessor :file_path

        def initialize(filename, langs, args = {})
            super(filename, langs, args)

            @file_path = args[:default_path].to_s
        end

        def file_path_for_locale(locale)
            require 'pathname' 
            Pathname.new(self.file_path) + "#{locale}.json"
        end

        def hash_to_output(content = {})
            return content.to_json
        end
    end
end
