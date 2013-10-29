require File.expand_path('../../../lib/json2csv/converter', __FILE__)
require File.expand_path('../../test_helper', __FILE__)

class JSON2CSV::ConverterTest < Test::Unit::TestCase
  
  def test_load_strings_with_wrong_file
    assert_raise(Errno::ENOENT) do
      output = JSON2CSV::Converter.new.load_strings "file that does not exist.strings"
    end
  end

  def test_load_strings
    expected_output = {"app_name" => "json2csv", "action_greetings" => "hello", "ANOTHER_STRING" => "testEN", "empty" => ""}
    output = JSON2CSV::Converter.new.load_strings "test/data/json.json"
    assert_equal expected_output, output
  end

  def test_initialize
    csv_filename = "file.csv"
    filenames = %w{"french.strings english.strings"}
    headers = %w{"constants french english"}
    converter = JSON2CSV::Converter.new({
        :csv_filename => csv_filename,
        :headers => headers,
        :filenames => filenames
    })

    assert_equal csv_filename, converter.csv_filename
    assert_equal headers, converter.headers
    assert_equal filenames, converter.filenames
  end

  def test_initialize_with_default_values
    converter = JSON2CSV::Converter.new
    assert_not_nil converter.csv_filename
  end
end