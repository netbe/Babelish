module Babelish
  require "nokogiri"
  class Android2CSV < Base2Csv

    def initialize(args = {:filenames => []})
      super(args)
    end

    def load_strings(strings_filename)
      strings = {}
      xml_file = File.open(strings_filename)

      parser = Nokogiri::XML(xml_file) do |config|
        config.strict.noent
      end
      parser.xpath("//string").each do |node|
        if !node.nil? && !node["name"].nil?
          if "#{node.children.first.class}" == "Nokogiri::XML::CDATA"
            strings.merge!(node["name"] => "<![CDATA[" + node.inner_html + "]]>")
          else
            strings.merge!(node["name"] => node.inner_html)
          end
        end
      end

      xml_file.close

      [strings, {}]
    end

  end
end
