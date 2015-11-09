module Babelish
  require "nokogiri"
  class Android2CSV < Base2Csv

    def initialize(args = {:filenames => []})
      super(args)
    end

    def load_strings(strings_filename)
      strings = {}
      # raise Errno::ENOENT unless File.exist?(strings_filename)
      xml_file = File.open(strings_filename)

      parser = Nokogiri::XML(xml_file) do |config|
        config.strict.noent
      end
      parser.xpath("//string").each do |node|
        if !node.nil? && !node["name"].nil?
          strings.merge!({node["name"] => node.inner_html})
        end
      end

      xml_file.close

      [strings, {}]
    end

  end
end
