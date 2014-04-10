require "test_helper"
class TestCSV2Android < Test::Unit::TestCase

    def test_converting_csv_to_xml
        csv_file = "test/data/test_data.csv"
        converter = CSV2Android.new(csv_file, 'English' => "en")
        converter.convert
        assert File.exists?("values-en/strings.xml"), "the ouptut file does not exist"

        #clean up
        system("rm -rf ./values-en")
    end

    def test_converting_csv_to_dotstrings_one_output_option
        csv_file = "test/data/test_data.csv"
        single_file = 'myApp.xml'
        converter = CSV2Android.new(csv_file,
                                        {'English' => "en"},
                                         :output_file => single_file)
        converter.convert
        assert File.exists?(single_file), "the ouptut file does not exist"

        #clean up
        system("rm -rf ./" + single_file)
    end
end
