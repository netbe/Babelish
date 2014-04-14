require 'test_helper'
class TestCSV2Strings < Test::Unit::TestCase

  def test_converting_csv_to_dotstrings
    csv_file = "test/data/test_data.csv"
    converter = Babelish::CSV2Strings.new(csv_file, 'English' => [:en])
    converter.convert
    assert File.exists?("en.lproj/Localizable.strings"), "the ouptut file does not exist"
  end

  def test_converting_csv_to_dotstrings_one_output_option
    csv_file = "test/data/test_data.csv"
    single_file = 'myApp.strings'
    converter = Babelish::CSV2Strings.new(csv_file,
    {'English' => [:en]},
    :output_file => single_file)
    converter.convert
    assert File.exists?(single_file), "the ouptut file does not exist"
  end
end
