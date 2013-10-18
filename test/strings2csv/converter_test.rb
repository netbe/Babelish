require File.expand_path('../../../lib/strings2csv/converter', __FILE__)
require File.expand_path('../../test_helper', __FILE__)

class Strings2CSV::ConverterTest < Test::Unit::TestCase
  
  def test_parse_dotstrings_line_with_good_string
    input = String.new(<<-EOS)
    "MY_CONSTANT" = "This is ok";
    EOS
    expected_output = {"MY_CONSTANT"=>"This is ok"}

    output = Strings2CSV::Converter.new.parse_dotstrings_line input
    assert_equal output, expected_output
  end

  def test_parse_dotstrings_line_with_single_quote
    input = String.new(<<-EOS)
    "MY_CONSTANT" = "This 'is' ok";
    EOS
    expected_output = {"MY_CONSTANT"=>"This 'is' ok"}

    output = Strings2CSV::Converter.new.parse_dotstrings_line input
    assert_equal output, expected_output
  end

  def test_parse_dotstrings_line_with_double_quotes
    input = String.new(<<-EOS)
    "MY_CONSTANT" = "This "is" ok";
    EOS
    expected_output = {"MY_CONSTANT"=>"This \"is\" ok"}

    output = Strings2CSV::Converter.new.parse_dotstrings_line input
    assert_equal output, expected_output
  end

  def test_parse_dotstrings_line_with_wrong_string
    input = String.new(<<-EOS)
    "MY_CONSTANT" = "wrong syntax"
    EOS

    output = Strings2CSV::Converter.new.parse_dotstrings_line input
    assert_nil output, "output should be nil with wrong syntax"
  end

  def test_load_strings_with_wrong_file
    assert_raise(Errno::ENOENT) do
      output = Strings2CSV::Converter.new.load_strings "file that does not exist.strings"
    end
  end

  def test_load_strings
    expected_output = {"ERROR_HANDLER_WARNING_DISMISS" => "OK", "ANOTHER_STRING" => "hello"}
    output = Strings2CSV::Converter.new.load_strings "test/data/test_data.strings"
    assert_equal expected_output, output
  end

  def test_dotstrings_to_csv
    converter = Strings2CSV::Converter.new(:filenames => ["test/data/test_data.strings"])
    keys, lang_order, strings = converter.convert(false)
    assert_equal ["test_data".to_sym], lang_order
    assert_equal ["ERROR_HANDLER_WARNING_DISMISS", "ANOTHER_STRING"], keys
    expected_strings = {lang_order[0] => {"ERROR_HANDLER_WARNING_DISMISS" => "OK", "ANOTHER_STRING" => "hello"}}
    assert_equal expected_strings, strings
  end

  def test_create_csv_file
    keys = ["ERROR_HANDLER_WARNING_DISMISS", "ANOTHER_STRING"]
    lang_order = [:"test_data"]
    strings = {lang_order[0] => {"ERROR_HANDLER_WARNING_DISMISS" => "OK", "ANOTHER_STRING" => "hello"}}
    
    converter = Strings2CSV::Converter.new(:headers => %w{variables english})

    converter.create_csv_file(keys, lang_order, strings)
    assert File.exist?(converter.csv_filename)

    #clean up
    system("rm -rf ./" + converter.csv_filename)
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

  def test_initialize_with_default_values
    converter = Strings2CSV::Converter.new
    assert_not_nil converter.csv_filename
  end
end