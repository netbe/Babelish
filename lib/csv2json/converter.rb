module CSV2JSON
    require File.expand_path('../../csv2base', __FILE__)

    class Converter < Csv2Base
        attr_accessor :file_path

        def initialize(filename, langs, args = {})
            super(filename, langs, args)

            @file_path = args[:default_path].to_s
        end

        def process_header(excludedCols, files, row, index)
            super(excludedCols, files, row, index)

            if files[index]
                files[index].each do |file|
                    file.write "{\n"
                end
            end
        end

        def process_footer(file)
            super(file)

            file.write "}"
        end

        def file_path_for_locale(locale)
            require 'pathname' 
            Pathname.new(self.file_path) + "#{locale}.json"
        end

        def get_row_format(row_key, row_value)
            return "\t\"#{row_key}\" = \"#{row_value}\"\n"
        end

    end
end
