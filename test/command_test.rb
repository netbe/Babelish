require 'test_helper'

require 'command'
class CommandTest < Test::Unit::TestCase
	def test_csv2strings_with_multiple_2_languages
		command = "./bin/csv2strings csv2strings"
		command += " test/data/test_data_multiple_langs.csv"
		command += " --langs=English:en French:fr"
		system(command)

		assert File.exist?("./en.lproj/Localizable.strings")
		assert File.exist?("./fr.lproj/Localizable.strings")

		#clean up
		system("rm -rf ./en.lproj/")
		system("rm -rf ./fr.lproj/")
	end

	def test_csv2strings_with_default_path
		command = "./bin/csv2strings csv2strings"
		command += " test/data/test_data_multiple_langs.csv"
		command += " --langs=English:en French:fr"
		command += " --default_path=mynewlocation"
		system(command)

		# testing
		assert File.exist?("./mynewlocation/en.lproj/Localizable.strings")
		assert File.exist?("./mynewlocation/fr.lproj/Localizable.strings")

		#clean up
		system("rm -rf ./mynewlocation")
	end

end
 