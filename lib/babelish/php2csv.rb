class Php2CSV < Base2Csv

    def initialize(args = {:filenames => []})
        super(args)
    end

    def load_strings(strings_filename)
        strings = {}
        File.open(strings_filename, 'r') do |strings_file|
            strings_file.read.each_line do |line|
                parsed_line = self.parse_dotstrings_line(line)
                unless parsed_line.nil?
                    converted_line = self.parse_dotstrings_line(line)
                    strings.merge!(converted_line) unless converted_line.nil?
                end
            end
        end
        strings
    end

    def parse_dotstrings_line(line)
        line.strip!
        if (line[0] != ?# and line[0] != ?=)
            m = line.match(/^[\$].*\[[\"\'](.*)[\"\']\]\s*=\s*[\"\'](.*)[\"\'];/)
            return {m[1] => m[2]} unless m.nil?
        end
    end
end
