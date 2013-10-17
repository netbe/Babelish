module CSV2Android
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
                    file.write "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                    file.write "<resources>\n"
                end
            end
        end

        def process_footer(file)
            super(file)

            file.write "</resources>"
        end

        def file_path_for_locale(locale)
            require 'pathname' 
            Pathname.new(self.file_path) + "values-#{locale}" + "strings.xml"
        end

        def get_row_format(row_key, row_value)
            return "\t<string name=\"#{row_key}\">#{row_value}</string>\n"
        end

    end
end
