require File.expand_path('../../../lib/strings2csv/converter', __FILE__)
require File.expand_path('../../test_helper', __FILE__)

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


  def test_create_csv_file
    # csv_filename
    # @headers ||= args[:headers]
    # @filenames ||= args[:filenames]


  end

  def test_initialize
    csv_filename = "file.csv"
    filenames = %w{"french.strings english.strings"}
    headers = %w{"constants french english"}
    converter = Strings2CSV::Converter.new({
        :csv_filename => csv_filename,
        :headers => headers,
        :filenames => filenames
    })

    assert_equal csv_filename, converter.csv_filename
    assert_equal headers, converter.headers
    assert_equal filenames, converter.filenames
  end
end