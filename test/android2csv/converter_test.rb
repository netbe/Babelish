require File.expand_path('../../../lib/android2csv/converter', __FILE__)
require File.expand_path('../../test_helper', __FILE__)

class Android2CSV::ConverterTest < Test::Unit::TestCase
  
  def test_load_strings_with_wrong_file
    assert_raise(Errno::ENOENT) do
      output = Android2CSV::Converter.new.load_strings "file that does not exist.strings"
    end
  end

  def test_load_strings
    expected_output = {"app_name" => "android2csv", "action_greetings" => "Hello", "ANOTHER_STRING" => "testEN", "empty" => ""}
    output = Android2CSV::Converter.new.load_strings "test/data/android.xml"
    assert_equal expected_output, output
  end

  def test_xml_to_csv
    converter = Android2CSV::Converter.new(:filenames => ["test/data/android.xml"])
    keys, lang_order, strings = converter.convert(false)
    assert_equal ["android".to_sym], lang_order
    assert_equal ["app_name", "action_greetings", "ANOTHER_STRING", "empty"], keys
    expected_strings = {lang_order[0] => {"app_name" => "android2csv", "action_greetings" => "Hello", "ANOTHER_STRING" => "testEN", "empty" => ""}}
    assert_equal expected_strings, strings
  end

  def test_create_csv_file
    keys = ["app_name", "action_greetings"]
    lang_order = [:"android"]
    strings = {lang_order[0] => {"app_name" => "android2csv", "action_greetings" => "Hello"}}
    
    converter = Android2CSV::Converter.new(:headers => %w{variables english})

    converter.create_csv_file(keys, lang_order, strings)
    assert File.exist?(converter.csv_filename)

    #clean up
    system("rm -rf ./" + converter.csv_filename)
  end

  def test_initialize
    csv_filename = "file.csv"
    filenames = %w{"french.strings english.strings"}
    headers = %w{"constants french english"}
    converter = Android2CSV::Converter.new({
        :csv_filename => csv_filename,
        :headers => headers,
        :filenames => filenames
    })

    assert_equal csv_filename, converter.csv_filename
    assert_equal headers, converter.headers
    assert_equal filenames, converter.filenames
  end

  def test_initialize_with_default_values
    converter = Android2CSV::Converter.new
    assert_not_nil converter.csv_filename
  end
end