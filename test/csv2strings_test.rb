begin
  require 'simplecov'
  SimpleCov.start do 
     add_filter "test"
  end
rescue LoadError
  puts 'Coverage disabled, enable by installing simplecov'
end


require 'test/unit'
require "mocha"
require 'csv2strings'


class Csv2stringsTest < Test::Unit::TestCase
  
  def test_parse_dotstrings_line_with_good_string
    input = String.new(<<-EOS)
    "MY_CONSTANT" = "This is ok";
    EOS
    expected_output = {"MY_CONSTANT"=>"This is ok"}

    output = CSV2Strings::Converter.parse_dotstrings_line input
    assert_equal output, expected_output
  end

  def test_parse_dotstrings_line_with_single_quote
    input = String.new(<<-EOS)
    "MY_CONSTANT" = "This 'is' ok";
    EOS
    expected_output = {"MY_CONSTANT"=>"This 'is' ok"}

    output = CSV2Strings::Converter.parse_dotstrings_line input
    assert_equal output, expected_output
  end

  def test_parse_dotstrings_line_with_double_quotes
    input = String.new(<<-EOS)
    "MY_CONSTANT" = "This "is" ok";
    EOS
    expected_output = {"MY_CONSTANT"=>"This \"is\" ok"}

    output = CSV2Strings::Converter.parse_dotstrings_line input
    assert_equal output, expected_output
  end

  def test_parse_dotstrings_line_with_wrong_string
    input = String.new(<<-EOS)
    "MY_CONSTANT" = "wrong syntax"
    EOS

    output = CSV2Strings::Converter.parse_dotstrings_line input
    assert_nil output, "output should be nil with wrong syntax"
  end

  def test_load_strings
    # file = File.stubs(:read).returns String.new(<<-EOS)
    # "MY_CONSTANT" = "This "is" ok";
    # "MY_CONSTANT_2" = "bla bla bla";
    # EOS
    # expected_output = {"MY_CONSTANT"=>"This \"is\" ok", "MY_CONSTANT_2" => "bla bla bla"}

    # puts file.stubs(:read)
    # File.open("test_file.strings", 'r')
    # # output = CSV2Strings::Converter.load_strings "test_file.strings"
    # # assert_equal output, expected_output
    # end
  end
end