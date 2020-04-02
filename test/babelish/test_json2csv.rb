require 'test_helper'
class JSON2CSVTest < Test::Unit::TestCase

  def test_load_strings_with_wrong_file
    assert_raise(Errno::ENOENT) do
      Babelish::JSON2CSV.new.load_strings "file that does not exist.strings"
    end
  end

  def test_load_strings
    expected_output = {"app_name" => "json2csv", "action_greetings" => "hello", "ANOTHER_STRING" => "testEN", "empty" => ""}
    output = Babelish::JSON2CSV.new.load_strings "test/data/json.json"
    assert_equal expected_output, output
  end

  def test_initialize
    csv_filename = "file.csv"
    filenames = %w{"french.strings english.strings"}
    headers = %w{"constants french english"}
    converter = Babelish::JSON2CSV.new({
      :csv_filename => csv_filename,
      :headers => headers,
      :filenames => filenames })

    assert_equal csv_filename, converter.csv_filename
    assert_equal headers, converter.headers
    assert_equal filenames, converter.filenames
  end

  def test_initialize_with_default_values
    converter = Babelish::JSON2CSV.new
    assert_not_nil converter.csv_filename
  end
end
