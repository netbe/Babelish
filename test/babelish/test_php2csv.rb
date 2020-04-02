require 'test_helper'
class TestPhp2CSV < Test::Unit::TestCase

  def test_parse_dotstrings_line_with_good_string
    input = String.new(<<-EOS)
    $lang['MY_CONSTANT'] = "This is ok";
    EOS
    expected_output = {"MY_CONSTANT" => "This is ok"}

    output = Babelish::Php2CSV.new.parse_dotstrings_line input
    assert_equal output, expected_output
  end

  def test_parse_dotstrings_line_with_single_quote
    input = String.new(<<-EOS)
    $lang['MY_CONSTANT'] = "This 'is' ok";
    EOS
    expected_output = {"MY_CONSTANT" => "This 'is' ok"}

    output = Babelish::Php2CSV.new.parse_dotstrings_line input
    assert_equal output, expected_output
  end

  def test_parse_dotstrings_line_with_double_quotes
    input = String.new(<<-EOS)
    $lang['MY_CONSTANT'] = "This "is" ok";
    EOS
    expected_output = {"MY_CONSTANT" => "This \"is\" ok"}

    output = Babelish::Php2CSV.new.parse_dotstrings_line input
    assert_equal output, expected_output
  end

  def test_parse_dotstrings_line_with_wrong_string
    input = String.new(<<-EOS)
    $lang['MY_CONSTANT'] = "wrong syntax"
    EOS

    output = Babelish::Php2CSV.new.parse_dotstrings_line input
    assert_nil output, "output should be nil with wrong syntax"
  end

  def test_load_strings_with_wrong_file
    assert_raise(Errno::ENOENT) do
      Babelish::Php2CSV.new.load_strings "file that does not exist.strings"
    end
  end

  def test_load_strings
    expected_output = {"app_name" => "php2csv", "action_greetings" => "Hello", "ANOTHER_STRING" => "testEN", "empty" => ""}
    output = Babelish::Php2CSV.new.load_strings "test/data/php_lang.php"
    assert_equal expected_output, output
  end

  def test_initialize
    csv_filename = "file.csv"
    filenames = %w{"french.php english.php"}
    headers = %w{"constants french english"}
    converter = Babelish::Php2CSV.new({
      :csv_filename => csv_filename,
      :headers => headers,
      :filenames => filenames })

    assert_equal csv_filename, converter.csv_filename
    assert_equal headers, converter.headers
    assert_equal filenames, converter.filenames
  end

  def test_initialize_with_default_values
    converter = Babelish::Php2CSV.new
    assert_not_nil converter.csv_filename
  end
end
