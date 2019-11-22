begin
  require "simplecov"
  require "coveralls"

  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start do
    add_filter "/test/"
  end
rescue LoadError
  puts "Coverage disabled, enable by installing simplecov"
end

require "test/unit"

require "babelish"

require "babelish/commandline"

require "webmock/test_unit"
require "vcr"
VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/vcr_cassettes"
  config.hook_into :webmock
end


def mock_google_doc_strings_file
  puts "mock"
  system 'echo {\"refresh_token\":\"fake_token\"} > .babelish.token'
  VCR.use_cassette("download_strings") do
    VCR.use_cassette("refresh_token") do
      yield if block_given?
    end
  end
  system "rm .babelish.token"
end
