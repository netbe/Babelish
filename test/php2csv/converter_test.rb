require File.expand_path('../../../lib/php2csv/converter', __FILE__)
require File.expand_path('../../test_helper', __FILE__)

class Php2CSV::ConverterTest < Test::Unit::TestCase
  
  def test_parse_dotstrings_line_with_good_string
    input = String.new(<<-EOS)
    $lang['MY_CONSTANT'] = "This is ok";
    EOS
    expected_output = {"MY_CONSTANT"=>"This is ok"}

    output = Php2CSV::Converter.new.parse_dotstrings_line input
    assert_equal output, expected_output
  end

  def test_parse_dotstrings_line_with_single_quote
    input = String.new(<<-EOS)
    $lang['MY_CONSTANT'] = "This 'is' ok";
    EOS
    expected_output = {"MY_CONSTANT"=>"This 'is' ok"}

    output = Php2CSV::Converter.new.parse_dotstrings_line input
    assert_equal output, expected_output
  end

  def test_parse_dotstrings_line_with_double_quotes
    input = String.new(<<-EOS)
    $lang['MY_CONSTANT'] = "This "is" ok";
    EOS
    expected_output = {"MY_CONSTANT"=>"This \"is\" ok"}

    output = Php2CSV::Converter.new.parse_dotstrings_line input
    assert_equal output, expected_output
  end

  def test_parse_dotstrings_line_with_wrong_string
    input = String.new(<<-EOS)
    $lang['MY_CONSTANT'] = "wrong syntax"
    EOS

    output = Php2CSV::Converter.new.parse_dotstrings_line input
    assert_nil output, "output should be nil with wrong syntax"
  end

  def test_load_strings_with_wrong_file
    assert_raise(Errno::ENOENT) do
      output = Php2CSV::Converter.new.load_strings "file that does not exist.strings"
    end
  end

  def test_load_strings
    expected_output = {"app_name" => "php2csv", "action_greetings" => "Hello", "ANOTHER_STRING" => "testEN", "empty" => ""}
    output = Php2CSV::Converter.new.load_strings "test/data/php_lang.php"
    assert_equal expected_output, output
  end

  def test_dotstrings_to_csv
    converter = Php2CSV::Converter.new(:filenames => ["test/data/php_lang.php"])
    keys, lang_order, strings = converter.convert(false)
    assert_equal ["php_lang".to_sym], lang_order
    assert_equal ["app_name", "action_greetings", "ANOTHER_STRING", "empty"], keys
    expected_strings = {lang_order[0] => {"app_name" => "php2csv", "action_greetings" => "Hello", "ANOTHER_STRING" => "testEN", "empty" => ""}}
    assert_equal expected_strings, strings
  end

  def test_create_csv_file
    keys = ["app_name", "action_greetings", "ANOTHER_STRING", "empty"]
    lang_order = [:"php_lang"]
    strings = {lang_order[0] => {"app_name" => "php2csv", "action_greetings" => "Hello", "ANOTHER_STRING" => "testEN", "empty" => ""}}
    
    converter = Php2CSV::Converter.new(:headers => %w{variables english})

    converter.create_csv_file(keys, lang_order, strings)
    assert File.exist?(converter.csv_filename)

    #clean up
    system("rm -rf ./" + converter.csv_filename)
  end

  def test_initialize
    csv_filename = "file.csv"
    filenames = %w{"french.php english.php"}
    headers = %w{"constants french english"}
    converter = Php2CSV::Converter.new({
        :csv_filename => csv_filename,
        :headers => headers,
        :filenames => filenames
    })

    assert_equal csv_filename, converter.csv_filename
    assert_equal headers, converter.headers
    assert_equal filenames, converter.filenames
  end

  def test_initialize_with_default_values
    converter = Php2CSV::Converter.new
    assert_not_nil converter.csv_filename
  end
end