require 'test_helper'
class TestBins < Test::Unit::TestCase

  def test_csv2strings_with_google_doc
    omit if ENV['TRAVIS']
    assert_nothing_raised do
      system("./bin/csv2strings --fetch --filename my_strings --langs English:en")
    end
    assert_equal $?.exitstatus, 0
  end

  def test_csv2strings_with_config_file
    system("cp .babelish.sample .babelish")

    assert_nothing_raised NameError do
      system("./bin/csv2strings")
    end
    assert_equal $?.exitstatus, 0
  end

  def teardown
    system("rm -f .babelish")
  end
end
