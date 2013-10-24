class CommandTest < Test::Unit::TestCase
	def test_csv2strings_with_multiple_2_languages
		command = "./bin/csv2strings"
		command += " --filename test/data/test_data_multiple_langs.csv"
		command += " --langs=English:en French:fr"
		system(command)

		assert File.exist?("./en.lproj/Localizable.strings")
		assert File.exist?("./fr.lproj/Localizable.strings")

		#clean up
		system("rm -rf ./en.lproj/")
		system("rm -rf ./fr.lproj/")
	end

	def test_csv2strings_with_default_path
		command = "./bin/csv2strings"
		command += " --filename test/data/test_data_multiple_langs.csv"
		command += " --langs=English:en French:fr"
		command += " --default_path=mynewlocation"
		system(command)

		# testing
		assert File.exist?("./mynewlocation/en.lproj/Localizable.strings"), "can't find output file for English"
		assert File.exist?("./mynewlocation/fr.lproj/Localizable.strings"), "can't find output file for French"

		#clean up
		system("rm -rf ./mynewlocation")
	end

	def test_strings2csv
		command = "./bin/strings2csv"
		command += " --filenames test/data/test_data.strings"
		system(command)

		assert File.exist?("translations.csv")

		#clean up
		system("rm -f translations.csv")
	end

	def test_strings2csv_with_dryrun_option
		command = "./bin/strings2csv"
		command += " --filenames test/data/test_data.strings"
		command += " --dryrun"
		system(command)

		assert !File.exist?("translations.csv")

		#clean up
		system("rm -f translations.csv")
	end

	def test_strings2csv_with_output_file
		command = "./bin/strings2csv"
		command += " -i=test/data/test_data.strings"
		command += " -o=myfile.csv"
		system(command)

		assert File.exist?("myfile.csv")

		#clean up
		system("rm -f myfile.csv")
	end

	def test_strings2csv_with_headers
		command = "./bin/strings2csv"
		command += " -i=test/data/test_data.strings"
		command += " -h=constants english"
		system(command)

		#TODO assertion or move test on at lib level

		#clean up
		system("rm -f translations.csv")
	end

	def test_strings2csv_with_two_files
		command = "./bin/strings2csv"
		command += " --filenames=test/data/test_en.strings test/data/test_fr.strings"
		command += " --headers=Constants English French"
		command += " -o=enfr.csv"
		system(command)
	end

	def test_strings2csv_with_empty_lines
		command = "./bin/strings2csv"
		command += " -i=test/data/test_with_nil.strings"
		command += " -o=test_with_nil.csv"
		assert_nothing_raised do
			system(command)
		end
		assert system("diff test_with_nil.csv test/data/test_with_nil.csv"), "no difference on output"

		#clean up
		system("rm -f test_with_nil.csv")
	end

end

