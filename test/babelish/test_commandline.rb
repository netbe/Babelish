require 'test_helper'
class TestCommandLine < Test::Unit::TestCase

  def test_init
    assert_nothing_raised do
      Commandline.new.init
    end
    # clean up
    system("rm -f .babelish")
  end

  def test_csv2base_with_config_file_all_required_options
    options = {
      :filename => "test/data/test_data_multiple_langs.csv",
      :langs => {"English" => "en", "French" => "fr"}
    }
    config_file = File.new(".babelish", "w")
    config_file.write options.to_yaml
    config_file.close

    assert_nothing_raised do
      Commandline.new.csv2strings
    end

    # clean up
    system("rm -rf ./en.lproj/")
    system("rm -rf ./fr.lproj/")
    system("rm -f .babelish")
  end


  def test_csv2base_without_filename_fails
    options = {
      :langs => {"English" => "en", "French" => "fr"}
    }
    config_file = File.new(".babelish", "w")
    config_file.write options.to_yaml
    config_file.close

    assert_raises do
      Commandline.new.csv2strings
    end

    # clean up
    system("rm -rf ./en.lproj/")
    system("rm -rf ./fr.lproj/")
    system("rm -f .babelish")
  end

  def test_base2csv_with_config_file_all_required_options
    options = {
      :filenames => ["test/data/test_en.strings", "test/data/test_fr.strings"],
    }
    config_file = File.new(".babelish", "w")
    config_file.write options.to_yaml
    config_file.close

    assert_nothing_raised do
      Commandline.new.strings2csv
    end

    # clean up
    system("rm -f translations.csv")
    system("rm -f .babelish")
  end

  def test_base2csv_with_config_without_filenames_fails
    options = {}
    config_file = File.new(".babelish", "w")
    config_file.write options.to_yaml
    config_file.close

    assert_raises do
      Commandline.new.strings2csv
    end

    # clean up
    system("rm -f .babelish")
  end

  def test_csv_download_without_gd_filename_fails
    options = {}
    config_file = File.new(".babelish", "w")
    config_file.write options.to_yaml
    config_file.close

    assert_raises do
      Commandline.new.csv_download
    end

    # clean up
    system("rm -f .babelish")
  end


  def test_csv_download_with_required_params
    omit if ENV['TRAVIS']
    options = {:gd_filename => "my_strings"}
    config_file = File.new(".babelish", "w")
    config_file.write options.to_yaml
    config_file.close

    assert_nothing_raised do
      Commandline.new.csv_download
    end

    # clean up
    system("rm -f .babelish")
  end

end
