require "test_helper"
class TestCSV2Php < Test::Unit::TestCase

  def test_converting_csv_to_dotstrings
    csv_file = "test/data/test_data.csv"
    converter = Babelish::CSV2Php.new(csv_file, 'English' => "en")
    converter.convert
    assert File.exist?("en/lang.php"), "the ouptut file does not exist"

    #clean up
    system("rm -rf ./en")
  end

  def test_converting_csv_to_dotstrings_one_output_option
    csv_file = "test/data/test_data.csv"
    single_file = 'myApp.php'
    converter = Babelish::CSV2Php.new(csv_file,
    {'English' => "en"},
    :output_basename => 'myApp',
    :ignore_lang_path => true)
    converter.convert
    assert File.exist?(single_file), "the ouptut file does not exist"

    #clean up
    system("rm -rf ./" + single_file)
  end
end
