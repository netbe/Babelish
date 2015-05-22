require 'test_helper'
class TestCsv2Base < Test::Unit::TestCase

  def test_initialize
    csv_filename = "file.csv"
    excluded_states = ["German"]
    state_column = "Local"
    keys_column = 23
    converter = Babelish::Csv2Base.new(csv_filename, {"English" => ["en"]}, {
      :excluded_states => excluded_states,
      :state_column => state_column,
      :keys_column => keys_column
    })

    assert_equal csv_filename, converter.csv_filename
    assert_equal excluded_states, converter.excluded_states
    assert_equal state_column, converter.state_column
    assert_equal keys_column, converter.keys_column
  end

  def test_initialize_with_default_values
    converter = Babelish::Csv2Base.new("file.csv", {"English" => ["en"]})
    assert_not_nil converter.csv_filename
  end

  def test_initialize_with_custom_separator
    converter = Babelish::Csv2Base.new("file.csv", {"English" => ["en"]}, {
      :csv_separator => ";"
      })
    assert_not_nil converter.csv_filename
  end

  def test_create_file_from_path
    test_file = "test_file.txt"
    Babelish::Csv2Base.new("file.csv", {"English" => ["en"]}).create_file_from_path test_file
    assert File.exist?(test_file)

    #clean up
    system("rm -rf ./" + test_file)
  end

  def test_get_row_format
    expected_output = "\"test_key\" = \"test_value\""
    output = Babelish::Csv2Base.new("file.csv", {"English" => ["en"]}).get_row_format("test_key", "test_value")
    assert_equal expected_output, output
  end
end
