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

require 'babelish'

require "babelish/commandline"

require 'webmock/test_unit'
require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
end
