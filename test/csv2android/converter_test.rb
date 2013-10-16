# Author: Markus Paeschke <a href="mailto:markus.paeschke@gmail.com">markus.paeschke@gmail.com</a> <a href="http://www.mpaeschke.de">http://www.mpaeschke.de</a>

require File.expand_path('../../../lib/csv2android/converter', __FILE__)
require File.expand_path('../../test_helper', __FILE__)

class CSV2Android::ConverterTest < Test::Unit::TestCase
  
	def test_converting_csv_to_xml
		csv_file = "test/data/test_data.csv"
		converter = CSV2Android::Converter.new(csv_file, 'English' => [:en])
		converter.convert
		assert File.exists?("values-en/strings.xml"), "the ouptut file does not exist"
	end

	def test_converting_csv_to_dotstrings_one_output_option
		csv_file = "test/data/test_data.csv"
		single_file = 'myApp.xml'
		converter = CSV2Android::Converter.new(csv_file, 
										{'English' => [:en]},
										 :output_file => single_file)
		converter.convert
		assert File.exists?(single_file), "the ouptut file does not exist"
	end
end