begin
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start do
     add_filter '/test/'
  end
rescue LoadError
  puts 'Coverage disabled, enable by installing simplecov'
end

require 'test/unit'

require 'csvconverter'

require "csvconverter/commands/strings2csv_command"
require "csvconverter/commands/csv2strings_command"

require "csvconverter/commands/android2csv_command"
require "csvconverter/commands/csv2android_command"