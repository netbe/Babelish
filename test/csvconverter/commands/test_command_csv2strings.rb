require 'test_helper'
class TestCommand < Test::Unit::TestCase

	def test_csv2strings_with_multiple_2_languages
    options = {
    	:filename => "test/data/test_data_multiple_langs.csv",
    	:langs => {"English" => "en", "French" => "fr"}
    }
    CSV2StringsCommand.new([], options).csv2strings

		assert File.exist?("./en.lproj/Localizable.strings")
		assert File.exist?("./fr.lproj/Localizable.strings")

		#clean up
		system("rm -rf ./en.lproj/")
		system("rm -rf ./fr.lproj/")
	end

	def test_csv2strings_with_default_path
		options = {
    	:filename => "test/data/test_data_multiple_langs.csv",
    	:langs => {"English" => "en", "French" => "fr"},
    	:default_path => "mynewlocation"
    }
    CSV2StringsCommand.new([], options).csv2strings

		# testing
		assert File.exist?("./mynewlocation/en.lproj/Localizable.strings"), "can't find output file for English"
		assert File.exist?("./mynewlocation/fr.lproj/Localizable.strings"), "can't find output file for French"

		#clean up
		system("rm -rf ./mynewlocation")
	end

end

