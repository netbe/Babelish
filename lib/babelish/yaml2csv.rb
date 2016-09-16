module Babelish
  require 'yaml'
  class YAML2CSV < Base2Csv

    def initialize(args = {:filenames => []})
      super(args)
    end


    def load_strings(yaml_filename)
      comments = {}
      raise Errno::ENOENT unless File.exist?(yaml_filename)
      yaml_content = YAML.load_file(yaml_filename)

      root_key = basename(yaml_filename)
      content = yaml_content["#{root_key}"]

      result = flatten(content)
      puts result.inspect
      return [result, comments]
    end

    # en -> application -> ....
    # transform to en.application.....
    def flatten(content, strings = {}, parent_key = [])
      content.each do |key, value|
        parent_key << key
        if value.is_a?(String)
          new_key = parent_key.join('.')
          strings[new_key] = value
          parent_key.pop()
        elsif value.is_a?(Hash)
          flatten(value, strings, parent_key)
        end
      end
      return strings
    end



  end
end
