require 'test_helper'
class TestBase2Csv < Test::Unit::TestCase

  def test_load_strings
    expected_output = [{}, {}]
    output = Babelish::Base2Csv.new.send :load_strings, nil
    assert_equal expected_output, output
  end

  def test_create_csv_file
    keys = ["ERROR_HANDLER_WARNING_DISMISS", "ANOTHER_STRING"]
    filename = "test_data"
    strings = {filename => {"ERROR_HANDLER_WARNING_DISMISS" => "OK", "ANOTHER_STRING" => "hello"}}

    converter = Babelish::Base2Csv.new(:headers => %w{variables english}, :filenames => [filename])

    converter.send :create_csv_file, keys, strings
    assert File.exist?(converter.csv_filename)

    #clean up
    system("rm -rf ./" + converter.csv_filename)
  end

  def test_initialize
    csv_filename = "file.csv"
    filenames = %w{"french.strings english.strings"}
    headers = %w{"constants french english"}
    converter = Babelish::Base2Csv.new({
        :csv_filename => csv_filename,
        :headers => headers,
        :filenames => filenames
    })

    assert_equal csv_filename, converter.csv_filename
    assert_equal headers, converter.headers
    assert_equal filenames, converter.filenames
  end

  def test_initialize_with_default_values
    converter = Babelish::Base2Csv.new
    assert_not_nil converter.csv_filename
  end
end
