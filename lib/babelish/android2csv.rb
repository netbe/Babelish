module Babelish
  require "nokogiri"
  class Android2CSV < Base2Csv

    def initialize(args = {:filenames => []})
      super(args)
    end

    def parse_comment_line(line)
      line.strip!
      if line[0] != ?# && line[0] != ?=
        m = line.match(/^\/\*(.*)\*\/\s*$/)
        return m[1].strip! unless m.nil?
      end
    end

    def load_strings(strings_filename)
      strings = {}
      comments = {}
      xml_file = File.open(strings_filename)

      parser = Nokogiri::XML(xml_file) do |config|
        config.strict.noent
      end

      previous_comment = nil
      parser.xpath("//resources").children.each do |node|
        if !node.nil? && !node["name"].nil?
          strings.merge!(node["name"] => node.inner_html)
          comments[node["name"]] = previous_comment if previous_comment
          previous_comment = nil
        end
        if node.comment?
          comment = node.content
          parsed_comment = parse_comment_line(comment)
          previous_comment = parsed_comment || comment
        end
      end

      xml_file.close

      [strings, comments]
    end

  end
end
