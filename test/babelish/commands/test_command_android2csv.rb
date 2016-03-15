require 'test_helper'
class TestAndroid2CSVCommand < Test::Unit::TestCase
  def test_android2csv
    options = {:filenames => ["test/data/android.xml"]}
    Commandline.new([], options).android2csv

    assert File.exist?("translations.csv")

    # clean up
    system("rm -f translations.csv")
  end

  def test_android2csv_with_dryrun_option
    options = {:filenames => ["test/data/android.xml"], :dryrun => true}
    Commandline.new([], options).android2csv

    assert !File.exist?("translations.csv")

    # clean up
    system("rm -f translations.csv")
  end

  def test_android2csv_with_output_file
    options = {:filenames => ["test/data/android.xml"], :csv_filename => "myfile.csv"}
    # -i, -o
    Commandline.new([], options).android2csv

    assert File.exist?("myfile.csv")

    # clean up
    system("rm -f myfile.csv")
  end

  def test_android2csv_with_headers
    options = {:filenames => ["test/data/android.xml"], :headers => ["constants", "english"]}
    # -i, -h
    Commandline.new([], options).android2csv

    #TODO assertion or move test on at lib level

    # clean up
    system("rm -f translations.csv")
  end

  def test_android2csv_with_two_files
    options = {
      :filenames => ["test/data/android-en.xml", "test/data/android-fr.xml"],
      :headers => %w{Constants English French},
      :csv_filename => "enfr.csv"
    }
    # --filenames, --headers, -o
    Commandline.new([], options).android2csv

    #TODO assertion

    # clean up
    system("rm -f enfr.csv")
  end

end
