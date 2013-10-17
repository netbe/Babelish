module Android2CSV
    require 'xmlsimple'
    require File.expand_path('../../base2csv', __FILE__)

    class Converter < Base2Csv

        attr_accessor :csv_filename, :headers, :filenames, :default_lang

        def initialize(args)
            super(args)
        end

        def load_strings(strings_filename)
            strings = {}
            raise Errno::ENOENT unless File.exist?(strings_filename)
            xmlfile = XmlSimple.xml_in(strings_filename)
                xmlfile['string'].each do |element|
                strings.merge!({element['name'] => element['content']})
            end
            strings
        end

    end
end
