require 'test_helper'
class TestBins < Test::Unit::TestCase

  def test_csv2strings_with_google_doc
    omit if ENV['TRAVIS']
    assert_nothing_raised do
      system("./bin/csv2strings --fetch --filename test.csv")
    end
    assert_equal $?.exitstatus, 0
  end

  def test_csv2strings_with_config_file
    system("cp .csvconverter.sample .csvconverter")

    assert_nothing_raised NameError do
      system("./bin/csv2strings")
    end
    assert_equal $?.exitstatus, 0
  end

  def teardown
    system("rm -f .csvconverter")
  end
end
