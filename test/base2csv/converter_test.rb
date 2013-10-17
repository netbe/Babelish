require File.expand_path('../../../lib/base2csv', __FILE__)
require File.expand_path('../../test_helper', __FILE__)

class Base2Csv::ConverterTest < Test::Unit::TestCase
  
  def test_load_strings_with_wrong_file
    assert_raise(Errno::ENOENT) do
      output = Base2Csv.new.load_strings "file that does not exist.strings"
    end
  end

  def test_load_strings
    expected_output = {}
    output = Base2Csv.new.load_strings "test/data/test_data.strings"
    assert_equal expected_output, output
  end

  def test_create_csv_file
    keys = ["ERROR_HANDLER_WARNING_DISMISS", "ANOTHER_STRING"]
    lang_order = [:"test_data"]
    strings = {lang_order[0] => {"ERROR_HANDLER_WARNING_DISMISS" => "OK", "ANOTHER_STRING" => "hello"}}
    
    converter = Base2Csv.new(:headers => %w{variables english})

    converter.create_csv_file(keys, lang_order, strings)
    assert File.exist?(converter.csv_filename)

    #clean up
    system("rm -rf ./" + converter.csv_filename)
  end

  def test_initialize
    csv_filename = "file.csv"
    filenames = %w{"french.strings english.strings"}
    headers = %w{"constants french english"}
    converter = Base2Csv.new({
        :csv_filename => csv_filename,
        :headers => headers,
        :filenames => filenames
    })

    assert_equal csv_filename, converter.csv_filename
    assert_equal headers, converter.headers
    assert_equal filenames, converter.filenames
  end

  def test_initialize_with_default_values
    converter = Base2Csv.new
    assert_not_nil converter.csv_filename
  end
end