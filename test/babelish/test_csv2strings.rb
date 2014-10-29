require 'test_helper'
class TestCSV2Strings < Test::Unit::TestCase

  def test_converting_csv_to_dotstrings
    csv_file = "test/data/test_data.csv"
    converter = Babelish::CSV2Strings.new(csv_file, 'English' => [:en])
    converter.convert
    assert File.exists?("en.lproj/Localizable.strings"), "the ouptut file does not exist"
    system("rm -rf en.lproj/")
  end

  def test_converting_csv_to_dotstrings_one_output_option
    csv_file = "test/data/test_data.csv"
    single_file = 'myApp.strings'
    converter = Babelish::CSV2Strings.new(csv_file,
    {'English' => [:en]},
    :output_basename => 'myApp',
    :ignore_lang_path => true)
    converter.convert
    assert File.exists?(single_file), "the ouptut file does not exist"
    system("rm -f #{single_file}")
  end

  def test_converting_csv_to_dotstrings_default_lang
    expected_output = String.new(<<-EOS)
"GREETINGS" = "Buenos dias";
"ANOTHER_STRING" = "testEN";
    EOS
    csv_file = "test/data/test_data_multiple_langs.csv"
    spanish_file = "es.lproj/Localizable.strings"
    converter = Babelish::CSV2Strings.new(csv_file,
    {'English' => [:en], "French" => "fr", "German" => "de", "Spanish" => "es"},
    :default_lang => "English")
    converter.convert
    assert File.exists?(spanish_file), "the ouptut file does not exist"
    result = File.read(spanish_file)
    assert_equal expected_output, result
    system("rm -rf *.lproj")
  end

  def test_converting_csv_to_dotstrings_with_no_default_lang_is_empty
    expected_output = String.new(<<-EOS)
"GREETINGS" = "Buenos dias";
"ANOTHER_STRING" = "";
    EOS
    csv_file = "test/data/test_data_multiple_langs.csv"
    spanish_file = "es.lproj/Localizable.strings"
    converter = Babelish::CSV2Strings.new(csv_file,
    {'English' => [:en], "French" => "fr", "German" => "de", "Spanish" => "es"})
    converter.convert
    assert File.exists?(spanish_file), "the ouptut file does not exist"
    result = File.read(spanish_file)
    assert_equal expected_output, result
    system("rm -rf *.lproj")
  end

  def test_converting_csv_to_dotstrings_default_lang_to_key
    expected_output = String.new(<<-EOS)
"GREETINGS" = "Buenos dias";
"ANOTHER_STRING" = "ANOTHER_STRING";
    EOS
    csv_file = "test/data/test_data_multiple_langs.csv"
    spanish_file = "es.lproj/Localizable.strings"
    converter = Babelish::CSV2Strings.new(csv_file,
    {'English' => [:en], "French" => "fr", "German" => "de", "Spanish" => "es"},
    :default_lang => "variables")
    converter.convert
    assert File.exists?(spanish_file), "the ouptut file does not exist"
    result = File.read(spanish_file)
    assert_equal expected_output, result
    system("rm -rf *.lproj")
  end

  def test_converting_csv_to_dotstrings_keys
    expected_output = String.new(<<-EOS)
"GREETINGS" = "Buenos dias";
"ANOTHER_STRING" = "ANOTHER_STRING";
    EOS
    csv_file = "test/data/test_data_multiple_langs.csv"
    converter = Babelish::CSV2Strings.new(csv_file,
    {'English' => [:en], "French" => "fr", "German" => "de", "Spanish" => "es"},
    :default_lang => "variables")
    converter.convert
    assert !converter.keys.empty?
    system("rm -rf *.lproj")
  end

  def test_converting_csv_to_dotstrings_with_percent
    expected_output = String.new(<<-EOS)
"GREETINGS" = "hello_%@";
"ANOTHER_STRING" = "hello";
    EOS
    csv_file = "test/data/test_data_with_percent.csv"
    converter = Babelish::CSV2Strings.new(csv_file, "English" => [:en])
    converter.convert
    result = File.read("en.lproj/Localizable.strings")
    assert_equal expected_output, result
    system("rm -rf *.lproj")
  end

  def test_converting_csv_to_dotstrings_with_spaces
    expected_output = String.new(<<-EOS)
"GREETINGS " = "hello ";
"ANOTHER_STRING" = " my other string with space at begin";
    EOS
    csv_file = "test/data/test_data_with_spaces.csv"
    converter = Babelish::CSV2Strings.new(csv_file, "English" => [:en])
    converter.convert
    result = File.read("en.lproj/Localizable.strings")
    assert_equal expected_output, result
    system("rm -rf *.lproj")
  end

  def test_converting_csv_to_dotstrings_with_percent_space
    expected_output = String.new(<<-EOS)
"GREETINGS" = "you have %d points";
"ANOTHER_STRING" = "this is a string with 10% of juice";
"ANOTHER_EXAMPLE" = "tu as fait 10% d'efforts";
    EOS
    csv_file = "test/data/test_data_with_percent_space.csv"
    converter = Babelish::CSV2Strings.new(csv_file, "English" => [:en])
    converter.convert
    result = File.read("en.lproj/Localizable.strings")
    assert_equal expected_output, result
    system("rm -rf *.lproj")
  end

  def test_converting_csv_to_dotstrings_with_stripping_option
    expected_output = String.new(<<-EOS)
"GREETINGS" = "hello";
"ANOTHER_STRING" = "my other string with space at begin";
    EOS
    csv_file = "test/data/test_data_with_spaces.csv"
    converter = Babelish::CSV2Strings.new(csv_file, {"English" => [:en]}, :stripping => true)
    converter.convert
    result = File.read("en.lproj/Localizable.strings")
    assert_equal expected_output, result
    system("rm -rf *.lproj")
  end
end
