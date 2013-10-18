module JSON2CSV
    require 'json'
    require File.expand_path('../../base2csv', __FILE__)

    class Converter < Base2Csv

        def initialize(args = {:filenames => []})
            super(args)
        end

        def load_strings(strings_filename)
            strings = {}
            raise Errno::ENOENT unless File.exist?(strings_filename)
            File.open(strings_filename, 'r') do |strings_file|
                strings = JSON.parse(strings_file).to_hash
            end
            strings
        end

    end
end
