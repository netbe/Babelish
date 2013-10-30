require "csvconverter/command"
class JSON2CSVCommand < Command
  default_task :json2csv

  desc "FILENAMES", "convert JSON files to CSV file"
  # required options but handled in method because of options read from yaml file
  method_option :filenames, :type => :array, :aliases => "-i", :desc => "location of JSON files (FILENAMES)"
  # optional options
  method_option :csv_filename, :type => :string, :aliases => "-o", :desc => "location of output file"
  method_option :headers, :type => :array, :aliases => "-h", :desc => "override headers of columns, default is name of input files and 'Variables' for reference"
  method_option :dryrun, :type => :boolean, :aliases => "-n", :desc => "prints out content of hash without writing file"
  def json2csv
    unless options.has_key?('filenames')
      say "No value provided for required options '--filenames'"
      help("json2csv")
      exit
    end
    converter = JSON2CSV.new(options)
  	debug_values = converter.convert(!options[:dryrun])
    say debug_values.inspect if options[:dryrun]   
  end
end