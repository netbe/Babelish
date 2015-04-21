require 'test_helper'
class TestStrings2CSV < Test::Unit::TestCase

  def test_parse_dotstrings_line_with_good_string
    input = String.new(<<-EOS)
    "MY_CONSTANT" = "This is ok";
    EOS
    expected_output = ["MY_CONSTANT","This is ok"]

    output = Babelish::Strings2CSV.new.parse_dotstrings_line input
    assert_equal expected_output, output 
  end

  def test_parse_dotstrings_line_with_single_quote
    input = String.new(<<-EOS)
    "MY_CONSTANT" = "This 'is' ok";
    EOS
    expected_output = ["MY_CONSTANT","This 'is' ok"]

    output = Babelish::Strings2CSV.new.parse_dotstrings_line input
    assert_equal expected_output, output
  end

  def test_parse_dotstrings_line_with_double_quotes
    input = String.new(<<-EOS)
    "MY_CONSTANT" = "This "is" ok";
    EOS
    expected_output = ["MY_CONSTANT","This \"is\" ok"]

    output = Babelish::Strings2CSV.new.parse_dotstrings_line input
    assert_equal expected_output, output
  end

  def test_parse_dotstrings_line_with_wrong_string
    input = String.new(<<-EOS)
    "MY_CONSTANT" = "wrong syntax"
    EOS

    output = Babelish::Strings2CSV.new.parse_dotstrings_line input
    assert_nil output, "output should be nil with wrong syntax"
  end

  def test_parse_dotstrings_line_with_comment
    input = String.new(<<-EOS)
    /* Class = "IBUIButton"; normalTitle = "Wibble"; ObjectID = "xxx-xx-123"; */
    EOS

    output = Babelish::Strings2CSV.new.parse_dotstrings_line input
    assert_nil output, "output should be nil with comment"
  end

  def test_parse_comment
    comment= "/* this is a comment */"
    output = Babelish::Strings2CSV.new.parse_comment_line comment
    assert_equal "this is a comment", output
  end

  def test_load_strings_with_wrong_file
    assert_raise(Errno::ENOENT) do
      output = Babelish::Strings2CSV.new.load_strings "file that does not exist.strings"
    end
  end

  def test_load_strings
    expected_output = [{"ERROR_HANDLER_WARNING_DISMISS" => "OK", "ANOTHER_STRING" => "hello"}, {}]
    output = Babelish::Strings2CSV.new.load_strings "test/data/test_data.strings"
    assert_equal expected_output, output
  end

  def test_load_strings_with_spaces
    expected_output = [{"name"=>"definition", 
                       "name1"=>"definition1",
                       "name2"=>"definition2",
                       "name3"=>"definition3",
                       "name4"=>"definition4",
                       "this is a name"=>"a definition"
                      },{}]
    output = Babelish::Strings2CSV.new.load_strings "test/data/test_space.strings"
    assert_equal expected_output, output
  end

  def test_load_strings_with_comments
    expected_output = [{"MY_CONSTANT"=>"This 'is' ok"}, {"MY_CONSTANT"=> "this is a comment"}]

    output = Babelish::Strings2CSV.new.load_strings "test/data/test_comments.strings"
    assert_equal expected_output, output
  end

  def test_load_strings_with_empty_lines
    assert_nothing_raised do
      output = Babelish::Strings2CSV.new.load_strings "test/data/test_with_nil.strings"
    end
  end

  def test_load_strings_with_empty_lines_and_comments
    assert_nothing_raised do
      output = Babelish::Strings2CSV.new.load_strings "test/data/xcode_empty.strings"
    end
  end

  def test_load_strings_with_genstrings_file
    assert_nothing_raised do
      output = Babelish::Strings2CSV.new.load_strings "test/data/genstrings.strings"
    end
  end

  def test_dotstrings_to_csv
    converter = Babelish::Strings2CSV.new(:filenames => ["test/data/test_data.strings"])
    keys, strings = converter.convert(false)
    assert_equal ["ERROR_HANDLER_WARNING_DISMISS", "ANOTHER_STRING"], keys

  end

  def test_create_csv_file
    keys = ["ERROR_HANDLER_WARNING_DISMISS", "ANOTHER_STRING"]
    filename = "test_data"
    strings = {filename => {"ERROR_HANDLER_WARNING_DISMISS" => "OK", "ANOTHER_STRING" => "hello"}}

    converter = Babelish::Strings2CSV.new(:headers => %w{variables english}, :filenames => [filename])

    converter.send :create_csv_file, keys, strings
    assert File.exist?(converter.csv_filename)

    #clean up
    system("rm -rf ./" + converter.csv_filename)
  end

  def test_initialize
    csv_filename = "file.csv"
    filenames = %w{"french.strings english.strings"}
    headers = %w{"constants french english"}
    converter = Babelish::Strings2CSV.new({
      :csv_filename => csv_filename,
      :headers => headers,
      :filenames => filenames
      })

      assert_equal csv_filename, converter.csv_filename
      assert_equal headers, converter.headers
      assert_equal filenames, converter.filenames
    end

  def test_initialize_with_default_values
    converter = Babelish::Strings2CSV.new
    assert_not_nil converter.csv_filename
  end

end
