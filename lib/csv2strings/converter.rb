module CSV2Strings
	class Converter < Csv2Base
        attr_accessor :file_path

        def initialize(filename, langs, args = {})
            super(filename, langs, args)

            @file_path = args[:default_path].to_s
        end

        def file_path_for_locale(locale)
            require 'pathname' 
            Pathname.new(self.file_path) + "#{locale}.lproj" + "Localizable.strings"
        end

        def get_row_format(row_key, row_value)
            return "\"#{row_key}\" = \"#{row_value}\";\n"
        end

	end
end
