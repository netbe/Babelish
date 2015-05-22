require "test_helper"
class TestCSV2Android < Test::Unit::TestCase

  def test_converting_csv_to_xml
    csv_file = "test/data/test_data.csv"
    converter = Babelish::CSV2Android.new(csv_file, 'English' => "en")
    converter.convert
    assert File.exists?("values-en/strings.xml"), "the ouptut file does not exist"

    #clean up
    system("rm -rf ./values-en")
  end

  def test_converting_csv_with_special_chars
    csv_file = "test/data/android_special_chars.csv"
    converter = Babelish::CSV2Android.new(csv_file, 'german' => "de")
    converter.convert
    assert File.exists?("values-de/strings.xml"), "the ouptut file does not exist"
    assert FileUtils.compare_file("values-de/strings.xml", "test/data/android_special_chars_test_result.xml")

    #clean up
    system("rm -rf ./values-de")
  end

  def test_converting_csv_to_dotstrings_one_output_option
    csv_file = "test/data/test_data.csv"
    single_file = 'myApp.xml'
    converter = Babelish::CSV2Android.new(csv_file,
    {'English' => "en"},
    :output_basename => 'myApp',
    :ignore_lang_path => true)
    converter.convert
    assert File.exists?(single_file), "the ouptut file does not exist"

    #clean up
    system("rm -rf ./" + single_file)
  end
end
