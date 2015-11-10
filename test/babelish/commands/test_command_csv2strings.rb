require 'test_helper'
class TestCSV2StringsCommand < Test::Unit::TestCase

  def test_csv2strings_with_multiple_2_languages
    options = {
    	:filename => "test/data/test_data_multiple_langs.csv",
    	:langs => {"English" => "en", "French" => "fr"}
    }
    Commandline.new([], options).csv2strings

    assert File.exist?("./en.lproj/Localizable.strings")
    assert File.exist?("./fr.lproj/Localizable.strings")

    # clean up
    system("rm -rf ./en.lproj/")
    system("rm -rf ./fr.lproj/")
  end

  def test_csv2strings_with_output_dir
    options = {
    	:filename => "test/data/test_data_multiple_langs.csv",
    	:langs => {"English" => "en", "French" => "fr"},
    	:output_dir => "mynewlocation"
    }
    Commandline.new([], options).csv2strings

    # testing
    assert File.exist?("./mynewlocation/en.lproj/Localizable.strings"), "can't find output file for English in mynewlocation folder"
    assert File.exist?("./mynewlocation/fr.lproj/Localizable.strings"), "can't find output file for French in mynewlocation folder"

    # clean up
    system("rm -rf ./mynewlocation")
  end

  def test_csv2strings_with_fetch_google_doc
    options = {
      :filename => "my_strings",
      :langs => {"English" => "en", "French" => "fr"},
      :fetch => true
    }

    VCR.use_cassette("my_strings_fetch_google_doc") do
      assert_nothing_raised do
        Commandline.new([], options).csv2strings
      end
    end

    # clean up
    system("rm -rf ./en.lproj/")
    system("rm -rf ./fr.lproj/")
  end

  def test_csv2strings_with_config_file
    system("cp .babelish.sample .babelish")

    assert_nothing_raised do
      Commandline.new.csv2strings
    end

    # clean up
    system("rm -rf ./en.lproj/")
    system("rm -rf ./fr.lproj/")
  end

  def test_csv2strings_with_output_basenames_option
    options = {
      :filename => "my_strings",
      :langs => {"English" => "en", "French" => "fr"},
      :fetch => true,
      :output_basenames => %w(sheet1 sheet2),
    }
    VCR.use_cassette("my_strings_fetch_google_doc") do
      Commandline.new([], options).csv2strings
    end

    # testing
    assert File.exist?("./en.lproj/sheet1.strings"), "can't find output file for sheet1 English"
    assert File.exist?("./fr.lproj/sheet1.strings"), "can't find output file for sheet1 French"
    assert File.exist?("./en.lproj/sheet2.strings"), "can't find output file for sheet2 English"
    assert File.exist?("./fr.lproj/sheet2.strings"), "can't find output file for sheet2 French"

    # clean up
    system("rm -rf ./en.lproj/")
    system("rm -rf ./fr.lproj/")
  end

  def test_csv2strings_with_ignore_lang_path_option
    options = {
      :filename => "my_strings",
      :langs => {"English" => "en"},
      :fetch => true,
      :ignore_lang_path => true,
      :output_basenames => %w(sheet1 sheet2),
    }

    VCR.use_cassette("my_strings_fetch_google_doc") do
      Commandline.new([], options).csv2strings
    end
    # testing
    assert File.exist?("./sheet1.strings"), "can't find output file for sheet1 English with_ignore_lang_path_option"
    assert File.exist?("./sheet2.strings"), "can't find output file for sheet2 English with_ignore_lang_path_option"

    # clean up
    system("rm -f sheet1.strings")
    system("rm -f sheet2.strings")
  end

  def test_csv2strings_with_ignore_lang_path_option_local
    options = {
      :filename => "test/data/test_data.csv",
      :langs => {"English" => "en"},
      :ignore_lang_path => true,
    }

    Commandline.new([], options).csv2strings
    # testing
    assert File.exist?("./Localizable.strings"), "can't find output file for English with_ignore_lang_path_option"

    # clean up
    system("rm -f ./Localizable.strings")
  end

  def test_csv2string_with_macros_filename
    options = {
      :filename => "test/data/test_data.csv",
      :macros_filename => "Babelish.h",
      :langs => { "English" => "en" }
    }

    Commandline.new([], options).csv2strings
    # testing
    assert File.exist?("./Babelish.h"), "can't find macros file"

    # clean up
    system("rm -f ./Localizable.strings")
    system("rm -f ./Babelish.h")
  end

  def teardown

    system("rm -f .babelish")
  end
end
