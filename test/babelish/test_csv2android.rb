require "test_helper"
class TestCSV2Android < Test::Unit::TestCase

  def test_converting_csv_to_xml
    csv_file = "test/data/test_data.csv"
    converter = Babelish::CSV2Android.new(csv_file, "English" => "en")
    converter.convert
    assert File.exist?("values-en/strings.xml"), "the ouptut file does not exist"

    # clean up
    system("rm -rf ./values-en")
  end

  def test_converting_csv_with_special_chars
    csv_file = "test/data/android_special_chars.csv"
    converter = Babelish::CSV2Android.new(csv_file, "german" => "de")
    converter.convert
    assert File.exist?("values-de/strings.xml"), "the ouptut file does not exist"
    assert_equal File.read("test/data/android_special_chars_test_result.xml"), File.read("values-de/strings.xml")

    # clean up
    system("rm -rf ./values-de")
  end

  def test_converting_csv_to_dotstrings_one_output_option
    csv_file = "test/data/test_data.csv"
    single_file = "myApp.xml"
    converter = Babelish::CSV2Android.new(
      csv_file,
      { "English" => "en" },
      :output_basename => "myApp",
      :ignore_lang_path => true
    )
    converter.convert
    assert File.exist?(single_file), "the ouptut file does not exist"

    # clean up
    system("rm -rf ./" + single_file)
  end

  def test_converting_with_comments
    csv_file = "test/data/test_data_with_comments.csv"
    french_file = "values-fr/strings.xml"
    expected_output = File.read("test/data/test_data_fr_with_comments.xml")
    converter = Babelish::CSV2Android.new(
      csv_file,
      { "French" => "fr" },
      :default_lang => "English",
      :comments_column => 5
    )
    converter.convert
    assert File.exist?(french_file), "the ouptut file does not exist"
    result = File.read(french_file)
    assert_equal expected_output, result

    # clean up
    system("rm -rf values-fr")
  end

  def test_converting_with_basename
    csv_file = "test/data/test_data.csv"
    converter = Babelish::CSV2Android.new(csv_file,
                                          { "English" => "en" },
                                          { output_basename: "super_strings" })
    converter.convert
    exist = File.exist?("values-en/super_strings.xml")
    assert exist, "the ouptut file does not exist"

    # clean up
    system("rm -rf ./values-en")
  end

  def test_android_character_escaping
    converter = Babelish::CSV2Android.new("test/data/test_data_with_characters_that_need_escaping.csv",
                                          { "English" => "en" },
                                          { output_basename: "escaped_strings" })
    converter.convert
    exist = File.exist?("values-en/escaped_strings.xml")
    assert exist, "the ouptut file does not exist"

    output = File.read("values-en/escaped_strings.xml")
    expected_output = File.read("test/data/test_data_with_characters_that_need_escaping.xml")

    assert_equal expected_output, output

    assert_true FileUtils.identical?("values-en/escaped_strings.xml",
                                     "test/data/test_data_with_characters_that_need_escaping.xml")

    # clean up
    system("rm -rf ./values-en")

  end
end
