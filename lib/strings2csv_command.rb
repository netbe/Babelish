$: << File.expand_path(File.join(File.dirname(__FILE__)))
require "command"

class Strings2CSVCommand < Command
  default_task :strings2csv

  desc "FILENAMES", "convert '.strings' files to CSV file"
  # required options but handled in method because of options read from yaml file
  method_option :filenames, :type => :array, :aliases => "-i", :desc => "location of strings files (FILENAMES)"
  # optional options
  method_option :csv_filename, :type => :string, :aliases => "-o", :desc => "location of output file"
  method_option :headers, :type => :array, :aliases => "-h", :desc => "override headers of columns, default is name of input files and 'Variables' for reference"
  method_option :dryrun, :type => :boolean, :aliases => "-n", :desc => "prints out content of hash without writing file"
  def strings2csv
    unless options.has_key?('filenames')
      puts "No value provided for required options '--filenames'"
      help("strings2csv")
      exit
    end
    converter = Strings2CSV::Converter.new(options)
  	debug_values = converter.dotstrings_to_csv(!options[:dryrun])
    puts debug_values.inspect if options[:dryrun]   
  end
end