require 'test_helper'
require "./lib/strings2csv/converter"


class Strings2CSV::ConverterTest < Test::Unit::TestCase
  
  def test_parse_dotstrings_line_with_good_string
    input = String.new(<<-EOS)
    "MY_CONSTANT" = "This is ok";
    EOS
    expected_output = {"MY_CONSTANT"=>"This is ok"}

    output = Strings2CSV::Converter.parse_dotstrings_line input
    assert_equal output, expected_output
  end

  def test_parse_dotstrings_line_with_single_quote
    input = String.new(<<-EOS)
    "MY_CONSTANT" = "This 'is' ok";
    EOS
    expected_output = {"MY_CONSTANT"=>"This 'is' ok"}

    output = Strings2CSV::Converter.parse_dotstrings_line input
    assert_equal output, expected_output
  end

  def test_parse_dotstrings_line_with_double_quotes
    input = String.new(<<-EOS)
    "MY_CONSTANT" = "This "is" ok";
    EOS
    expected_output = {"MY_CONSTANT"=>"This \"is\" ok"}

    output = Strings2CSV::Converter.parse_dotstrings_line input
    assert_equal output, expected_output
  end

  def test_parse_dotstrings_line_with_wrong_string
    input = String.new(<<-EOS)
    "MY_CONSTANT" = "wrong syntax"
    EOS

    output = Strings2CSV::Converter.parse_dotstrings_line input
    assert_nil output, "output should be nil with wrong syntax"
  end

  def test_load_strings_with_wrong_file
    assert_raise(Errno::ENOENT) do
      output = Strings2CSV::Converter.load_strings "file that does not exist.strings"
    end
  end

  def test_load_strings
    expected_output = {"ERROR_HANDLER_WARNING_DISMISS" => "OK", "ANOTHER_STRING" => "hello"}
    output = Strings2CSV::Converter.load_strings "test/data/test_data.strings"
    assert_equal expected_output, output
  end
end