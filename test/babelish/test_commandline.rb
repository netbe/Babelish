require 'test_helper'
class TestCommandLine < Test::Unit::TestCase

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

    #clean up
    system("rm -rf ./en.lproj/")
    system("rm -rf ./fr.lproj/")
    system("rm -f .babelish")
  end

end
