require 'test_helper'
class TestCSV2JSON < Test::Unit::TestCase

  def test_converting_csv_to_dotstrings
    csv_file = "test/data/test_data.csv"
    converter = Babelish::CSV2JSON.new(csv_file, 'English' => "en")
    converter.convert
    assert File.exist?("en.json"), "the ouptut file does not exist"

    # clean up
    system("rm -rf en.json")
  end

  def test_converting_csv_to_dotstrings_one_output_option
    csv_file = "test/data/test_data.csv"
    single_file = 'myfile.json'
    converter = Babelish::CSV2JSON.new(csv_file,
    {'English' => "en"},
    :output_basename => 'myfile',
    :ignore_lang_path => true)
    converter.convert
    assert File.exist?(single_file), "the ouptut file does not exist"

    # clean up
    system("rm -rf ./" + single_file)
  end

  def test_converting_csv_to_json_with_unpretty_json
    csv_file = "test/data/test_data.csv"
    expected_json_filename = "test_unpretty_json.json"
    given_json_filename = "output.json"

    expected_json = File.read("test/data/" + expected_json_filename)
    converter = Babelish::CSV2JSON.new(csv_file, { "English" => "en" }, output_basename: "output", pretty_json: false)
    converter.convert
    given_json = File.read(given_json_filename)
    assert_equal(expected_json, given_json, "JSON file has incorrect format")

    # clean up
    system("rm -rf ./" + given_json_filename)
  end

  def test_converting_csv_to_json_with_pretty_json
    csv_file = "test/data/test_data.csv"
    expected_json_filename = "test_pretty_json.json"
    given_json_filename = "output.json"

    expected_json = File.read("test/data/" + expected_json_filename)
    converter = Babelish::CSV2JSON.new(csv_file, { "English" => "en" }, output_basename: "output", pretty_json: true)
    converter.convert
    given_json = File.read(given_json_filename)
    assert_equal(expected_json, given_json, "JSON file has incorrect format")

    # clean up
    system("rm -rf ./" + given_json_filename)
  end
end
