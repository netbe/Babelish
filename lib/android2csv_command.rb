# Author: Markus Paeschke <a href="mailto:markus.paeschke@gmail.com">markus.paeschke@gmail.com</a> <a href="http://www.mpaeschke.de">http://www.mpaeschke.de</a>
# 
# Command class to encapsulate the android2csv class.

$: << File.expand_path(File.join(File.dirname(__FILE__)))
require "command"

class Android2CSVCommand < Command
  default_task :android2csv

  desc "FILENAMES", "convert '.strings' files to CSV file"
  # required options but handled in method because of options read from yaml file
  method_option :filenames, :type => :array, :aliases => "-i", :desc => "location of android strings xml files (FILENAMES)"
  # optional options
  method_option :csv_filename, :type => :string, :aliases => "-o", :desc => "location of output file"
  method_option :headers, :type => :array, :aliases => "-h", :desc => "override headers of columns, default is name of input files and 'Variables' for reference"
  method_option :dryrun, :type => :boolean, :aliases => "-n", :desc => "prints out content of hash without writing file"
  def android2csv
    unless options.has_key?('filenames')
      say "No value provided for required options '--filenames'"
      help("android2csv")
      exit
    end
    converter = Android2CSV::Converter.new(options)
  	debug_values = converter.convert(!options[:dryrun])
    say debug_values.inspect if options[:dryrun]   
  end
end