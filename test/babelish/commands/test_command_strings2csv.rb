require 'test_helper'
class TestStrings2CSVCommand < Test::Unit::TestCase

  def test_strings2csv
    options = {:filenames => ["test/data/test_data.strings"]}
    Babelish::Command.new([], options).strings2csv

    assert File.exist?("translations.csv")

    #clean up
    system("rm -f translations.csv")
  end

  def test_strings2csv_with_dryrun_option
    options = {:filenames => ["test/data/test_data.strings"], :dryrun => true}
    Babelish::Command.new([], options).strings2csv

    assert !File.exist?("translations.csv")

    #clean up
    system("rm -f translations.csv")
  end

  def test_strings2csv_with_output_file
    options = {:filenames => ["test/data/test_data.strings"], :csv_filename => "myfile.csv"}
    # -i, -o
    Babelish::Command.new([], options).strings2csv

    assert File.exist?("myfile.csv")

    #clean up
    system("rm -f myfile.csv")
  end

  def test_strings2csv_with_headers
    options = {:filenames => ["test/data/test_data.strings"], :headers => ["constants", "english"]}
    # -i, -h
    Babelish::Command.new([], options).strings2csv

    #TODO assertion or move test on at lib level

    #clean up
    system("rm -f translations.csv")
  end

  def test_strings2csv_with_two_files
    options = {
      :filenames => ["test/data/test_en.strings", "test/data/test_fr.strings"],
      :headers => %w{Constants English French},
      :csv_filename => "enfr.csv"
    }
    # --filenames, --headers, -o
    Babelish::Command.new([], options).strings2csv

    #TODO assertion

    #clean up
    system("rm -f enfr.csv")
  end

  def test_strings2csv_with_empty_lines
    options = {
      :filenames => ["test/data/test_with_nil.strings"],
      :csv_filename => "test_with_nil.csv"
    }
    # -i, -o


    assert_nothing_raised do
      Babelish::Command.new([], options).strings2csv
    end
    assert system("diff test_with_nil.csv test/data/test_with_nil.csv"), "no difference on output"

    #clean up
    system("rm -f test_with_nil.csv")
  end

  def test_strings2csv_utf16
    options = {
      :filenames => ["test/data/test_utf16.strings"],
      :csv_filename => "test_utf16.csv"
    }
    # -i, -o


    assert_nothing_raised do
      Babelish::Command.new([], options).strings2csv
    end

    #clean up
    system("rm -f test_utf16.csv")

  end

end
