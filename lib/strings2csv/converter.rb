module Strings2CSV
    require File.expand_path('../../base2csv', __FILE__)

    class Converter < Base2Csv

        def initialize(args = {:filenames => []})
            super(args)
        end

        def parse_dotstrings_line(line)
            line.strip!
            if (line[0] != ?# and line[0] != ?=)
                m = line.match(/^[^\"]*\"(.+)\"[^=]+=[^\"]*\"(.*)\";/)
                return {m[1] => m[2]} unless m.nil?
            end
        end

        def load_strings(strings_filename)
            strings = {}
            File.open(strings_filename, 'r') do |strings_file|
                strings_file.read.each_line do |line|     
                    strings.merge!(self.parse_dotstrings_line(line))
                end
            end
            strings
        end

    end
end
