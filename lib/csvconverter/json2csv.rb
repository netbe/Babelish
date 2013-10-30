require 'json'
class JSON2CSV < Base2Csv

    def initialize(args = {:filenames => []})
        super(args)
    end

    def load_strings(strings_filename)
        strings = {}
        raise Errno::ENOENT unless File.exist?(strings_filename)
        json_file = File.open(strings_filename, 'r')
        json_string = json_file.read
        json_file.close
        strings = JSON.parse(json_string).to_hash
        return strings
    end

end
