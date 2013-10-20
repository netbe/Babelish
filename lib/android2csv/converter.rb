module Android2CSV
    require 'xmlsimple'
    require File.expand_path('../../base2csv', __FILE__)

    class Converter < Base2Csv

        def initialize(args = {:filenames => []})
            super(args)
        end

        def load_strings(strings_filename)
            strings = {}
            raise Errno::ENOENT unless File.exist?(strings_filename)

            xmlfile = XmlSimple.xml_in(strings_filename)
            xmlfile['string'].each do |element|
                if !element.nil? && !element['name'].nil?
                    content = element['content'].nil? ? '' : element['content']
                    strings.merge!({element['name'] => content})
                end
            end

            strings
        end

    end
end
