module Babelish
  class CSV2Php < Csv2Base
    attr_accessor :php_tag

    def initialize(filename, langs, args = {})
      super(filename, langs, args)
      # TODO: list this arg in commandline
      @php_tag = args[:php_tag].nil? ? 'lang' : args[:php_tag]
    end

    def language_filepaths(language)
      require 'pathname'
      filepath = Pathname.new(@output_dir) + "#{language.code}" + "lang.php"
      return filepath ? [filepath] : []
    end

    def get_row_format(row_key, row_value, indentation = 0)
      return "$" + @php_tag + "['#{row_key}']" + " " * indentation + " = \"#{row_value}\";\n"
    end

    def extension
      "php"
    end
  end
end
