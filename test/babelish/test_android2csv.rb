require 'test_helper'
class TestAndroid2CSV < Test::Unit::TestCase

  def test_load_strings_with_wrong_file
    assert_raise(Errno::ENOENT) do
      output = Babelish::Android2CSV.new.load_strings "file that does not exist.strings"
    end
  end

  def test_load_strings
    expected_output = [{"app_name" => "android2csv", "action_greetings" => "Hello", "ANOTHER_STRING" => "testEN", "empty" => ""}, {}]
    output = Babelish::Android2CSV.new.load_strings "test/data/android.xml"
    assert_equal expected_output, output
  end

  def test_initialize
    csv_filename = "file.csv"
    filenames = %w{french.strings english.strings}
    headers = %w{constants french english}
    converter = Babelish::Android2CSV.new(
      :csv_filename => csv_filename,
      :headers => headers,
      :filenames => filenames)

    assert_equal csv_filename, converter.csv_filename
    assert_equal headers, converter.headers
    assert_equal filenames, converter.filenames
  end

  def test_load_strings_with_comments
    expected_output = [
      {
        "app_name" => "android2csv",
        "action_greetings" => "Hello",
        "ANOTHER_STRING" => "testEN",
        "empty" => "" 
      },
      {
        "app_name" => "This is the app name",
        "action_greetings" => "This is a greeting",
        "ANOTHER_STRING" => "This is another string",
        "empty" => "This is an empty string"
      }
    ]
    output = Babelish::Android2CSV.new.load_strings "test/data/android-comments.xml"
    assert_equal expected_output, output
  end

  def test_initialize_with_default_values
    converter = Babelish::Android2CSV.new
    assert_not_nil converter.csv_filename
  end

  def test_special_chars
    csv_filename = "./android_special_chars_output.csv"
    filenames = "test/data/android_special_chars.xml"
    headers = %w{variables german}

    converter = Babelish::Android2CSV.new(
      :csv_filename => csv_filename,
      :headers => headers,
      :filenames => [filenames])

    converter.convert

    assert File.exist?(converter.csv_filename)
    assert_equal File.read("test/data/android_special_chars.csv"), File.read(csv_filename)

    # clean up
    system("rm -rf ./" + csv_filename)
  end
end
