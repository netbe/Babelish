require 'pathname'
module Babelish
  class Csv2Base
    attr_accessor :output_dir, :output_basename
    attr_accessor :ignore_lang_path
    attr_accessor :langs
    attr_accessor :csv_filename
    attr_accessor :default_lang
    attr_accessor :excluded_states, :state_column, :keys_column
    attr_accessor :languages

    def initialize(filename, langs, args = {})
      default_args = {
        :excluded_states => [],
        :state_column => nil,
        :keys_column => 0
      }

      args = default_args.merge!(args)
      args = Thor::CoreExt::HashWithIndifferentAccess.new(args)
      @langs = langs

      # check input types
      raise ArgumentError.new("wrong value of filename: #{filename.inspect}") unless filename.is_a?(String)
      if !@langs.is_a?(Hash) || @langs.size == 0
        raise ArgumentError.new("wrong format or/and langs parameter: #{@langs.inspect}")
      end

      @output_basename = args[:output_basename]
      @output_dir = args[:output_dir].to_s
      @csv_filename = filename
      @excluded_states = args[:excluded_states]
      @state_column = args[:state_column]
      @keys_column = args[:keys_column]
      @default_lang = args[:default_lang]
      @ignore_lang_path = args[:ignore_lang_path]
      @stripping = args[:stripping]
      @languages = []
    end

    def create_file_from_path(file_path)
      path = File.dirname(file_path)
      FileUtils.mkdir_p path
      return File.new(file_path, "w")
    end

    def keys
      @languages.each do |lang|
        next unless lang
        return lang.content.keys unless lang.content.keys.empty?
      end
      return []
    end

    def table
      output_basename
    end

    def language_filepaths(language)
      #implement in subclass
      []
    end

    def extension
      #implement in subclass
      ""
    end

    def default_filepath
      Pathname.new(@output_dir) + "#{output_basename}.#{extension}"
    end

    def process_value(row_value, default_value)
      value = row_value.nil? ? default_value : row_value
      value = "" if value.nil?
      value.gsub!(/\\*\"/, "\\\"") # escape double quotes
      value.gsub!(/\n/, "\\n") # replace new lines with \n, dont strip
      value.strip! if @stripping
      return value.to_utf8
    end

    def get_row_format(row_key, row_value, indentation = 0)
      return "\"" + row_key + "\"" + " " * indentation + " = \"" + row_value + "\""
    end

    # Convert csv file to multiple Localizable.strings files for each column
    def convert(name = @csv_filename)
      rowIndex     = 0
      excludedCols = []
      defaultCol   = 0

      CSV.foreach(name, :quote_char => '"', :col_sep => ',', :row_sep => :auto) do |row|

        if rowIndex == 0
          #check there's at least two columns
          return unless row.count > 1
        else
          #skip empty lines (or sections)
          next if row == nil or row[@keys_column].nil?
        end

        # go through columns
        row.size.times do |i|
          next if excludedCols.include? i

          #header
          if rowIndex == 0
            # defaultCol can be the keyValue
            defaultCol = i if self.default_lang == row[i]
            # ignore all headers not listed in langs to create files
            (excludedCols << i and next) unless @langs.has_key?(row[i])

            language = Language.new(row[i])
            if @langs[row[i]].is_a?(Array)
              @langs[row[i]].each do |id|
                language.add_language_id(id.to_s)
              end
            else
              language.add_language_id(@langs[row[i]].to_s)
            end
            @languages[i] = language
          elsif !@state_column || (row[@state_column].nil? || row[@state_column] == '' || !@excluded_states.include?(row[@state_column]))
            key = row[@keys_column]
            key.strip! if @stripping
            default_value =  self.default_lang ? row[defaultCol] : nil
            value = self.process_value(row[i], default_value)

            @languages[i].add_content_pair(key, value)
          end
        end

        rowIndex += 1
      end

      write_content
    end

    def write_content
      info = "List of created files:\n"
      count = 0
      @languages.each do |language|
        next if language.nil?

        files = []
        if @ignore_lang_path
          files << create_file_from_path(default_filepath)
        else
          language_filepaths(language).each do |filename|
            files << create_file_from_path(filename)
          end
        end
        files.each do |file|
          file.write hash_to_output(language.content)
          info += "- #{File.absolute_path(file)}\n"
          count += 1

          file.close
        end
      end

      info = "Created #{count} files.\n" + info
      return info
    end

    def hash_to_output(content = {})
      output = ''
      indentation = content.map(&:first).max{|a, b| a.length <=> b.length}.length
      if content && content.size > 0
        content.each do |key, value|
          output += get_row_format(key, value, indentation - key.length)
        end
      end
      return output
    end
  end
end
