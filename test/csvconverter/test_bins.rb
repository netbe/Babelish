require 'test_helper'
class TestBins < Test::Unit::TestCase

  def test_csv2strings_with_google_doc
    assert_nothing_raised do
      system("./bin/csv2strings --fetch --filename test.csv")
    end
    assert_equal $?.exitstatus, 0
  end
end
