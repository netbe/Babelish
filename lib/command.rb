$: << File.expand_path(File.join(File.dirname(__FILE__)))
require 'yaml'
require 'thor'
require 'csvconverter'

class Command < Thor

  desc "csv2strings CSV_FILENAME", "convert CSV file to '.strings' file"
  method_option :langs, :type => :hash, :required => true, :aliases => "-L", :desc => "languages to convert"
  method_option :excluded_states, :type => :array, :required => false, :aliases => "-x", :desc => "Exclude rows with given state"
  method_option :state_column, :type => :numeric, :required => false, :aliases => "-s", :desc => "Position of column for state if any"
  method_option :keys_column,  :type => :numeric, :default => 0, :required => false, :aliases => "-k", :desc => "Position of column for keys"
  method_option :default_lang, :type => :string,  :required => false, :aliases => "-l", :desc => "default language to use for empty values if any"
  method_option :default_path, :type => :string,  :required => false, :aliases => "-p", :desc => "Path of output files"
  def csv2strings(filename)
	args = options.dup
	args.delete(:langs)
  	converter = CSV2Strings::Converter.new(filename, options[:langs], args)
  	converter.csv_to_dotstrings    
  end

  desc "strings2csv", "convert '.strings' files to CSV file"
  method_option :filenames, :type => :array, :required => true, :aliases => "-i", :desc => "location of strings files"
  method_option :csv_filename, :type => :string, :default => "translations.csv", :aliases => "-o", :required => false, :desc => "location of output file"
  method_option :dryrun, :type => :boolean, :default => false, :required => false, :aliases => "-n", :desc => "prints out content of hash without writing file"
  def strings2csv
    converter = Strings2CSV::Converter.new(options)
  	debug_values = converter.dotstrings_to_csv(!options[:dryrun])
    puts debug_values.inspect if options[:dryrun]   
  end

end