module Babelish
  module XcodeMacros

    def self.write_macros(file_path, table, keys)
      file = File.new(file_path, "w")
      file.write self.process(table, keys)
      file.close
    end

    def self.process(table, keys)
      content = ""
      keys.each do |key|
        content << String.new(<<-EOS)
#define #{key} NSLocalizedStringFromTable(@"#{key}",@"#{table}",@"")
        EOS
      end
      content
    end

  end
end
