begin
  require 'simplecov'
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
