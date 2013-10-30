require 'test_helper'
class TestCSV2AndroidCommand < Test::Unit::TestCase

	def test_csv2android_with_multiple_2_languages
		command = "./bin/csv2android"
		command += " --filename test/data/test_data_multiple_langs.csv"
		command += " --langs=English:en French:fr"
		system(command)

		assert File.exist?("./values-en/strings.xml")
		assert File.exist?("./values-fr/strings.xml")

		#clean up
		system("rm -rf ./values-en/")
		system("rm -rf ./values-fr/")
	end

	def test_csv2android_with_default_path
		command = "./bin/csv2android"
		command += " --filename test/data/test_data_multiple_langs.csv"
		command += " --langs=English:en French:fr"
		command += " --default_path=mynewlocation"
		system(command)

		# testing
		assert File.exist?("./mynewlocation/values-en/strings.xml"), "can't find output file for English"
		assert File.exist?("./mynewlocation/values-fr/strings.xml"), "can't find output file for French"

		#clean up
		system("rm -rf ./mynewlocation")
	end

end
 