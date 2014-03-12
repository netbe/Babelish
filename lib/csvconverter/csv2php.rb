class CSV2Php < Csv2Base
    attr_accessor :php_tag
    attr_accessor :file_path

    def initialize(filename, langs, args = {})
        super(filename, langs, args)

        @php_tag = args[:php_tag].nil? ? 'lang' : args[:php_tag]
        @file_path = args[:default_path].to_s
    end

    def language_filepaths(language)
        require 'pathname'
        filepath = Pathname.new(self.file_path) + "#{language.code}" + "lang.php"
        return filepath ? [filepath] : []
    end

    def get_row_format(row_key, row_value)
        return "$" + @php_tag + "['#{row_key}'] = \"#{row_value}\";\n"
    end

end
