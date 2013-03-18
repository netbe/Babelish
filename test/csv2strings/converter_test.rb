require File.expand_path('../../../lib/csv2strings/converter', __FILE__)
require File.expand_path('../../test_helper', __FILE__)

class CSV2Strings::ConverterTest < Test::Unit::TestCase
  
	def test_converting_csv_to_dotstrings
		csv_file = "test/data/test_data.csv"
		converter = CSV2Strings::Converter.new(csv_file)
		converter.csv_to_dotstrings

	end

end