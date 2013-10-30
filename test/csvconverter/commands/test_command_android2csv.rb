require 'test_helper'
class TestAndroid2CSVCommand < Test::Unit::TestCase
	def test_android2csv
		command = "./bin/android2csv"
		command += " --filenames test/data/android.xml"
		system(command)

		assert File.exist?("translations.csv")

		#clean up
		system("rm -f translations.csv")
	end

	def test_android2csv_with_dryrun_option
		command = "./bin/android2csv"
		command += " --filenames test/data/android.xml"
		command += " --dryrun"
		system(command)

		assert !File.exist?("translations.csv")

		#clean up
		system("rm -f translations.csv")
	end

	def test_android2csv_with_output_file
		command = "./bin/android2csv"
		command += " -i=test/data/android.xml"
		command += " -o=myfile.csv"
		system(command)

		assert File.exist?("myfile.csv")

		#clean up
		system("rm -f myfile.csv")
	end

	def test_android2csv_with_headers
		command = "./bin/android2csv"
		command += " -i=test/data/android.xml"
		command += " -h=constants english"
		system(command)

		#TODO assertion or move test on at lib level

		#clean up
		system("rm -f translations.csv")
	end

	def test_android2csv_with_two_files
		command = "./bin/android2csv"
		command += " --filenames=test/data/android-en.xml test/data/android-fr.xml"
		command += " --headers=Constants English French"
		command += " -o=enfr.csv"
		system(command)

		assert File.exist?("enfr.csv")

		#clean up
		system("rm -f enfr.csv")
	end
end
 