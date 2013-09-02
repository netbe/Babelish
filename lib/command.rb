$: << File.expand_path(File.join(File.dirname(__FILE__)))
require 'yaml'
require 'thor'
require 'csvconverter'

class Command < Thor

  desc "CSV_FILENAME", "convert CSV file (CSV_FILENAME) to '.strings' file"
  method_option :filename, :type => :string, :desc => "CSV file"
  method_option :langs, :type => :hash, :aliases => "-L", :desc => "Languages to convert"
  method_option :excluded_states, :type => :array, :aliases => "-x", :desc => "Exclude rows with given state"
  method_option :state_column, :type => :numeric, :aliases => "-s", :desc => "Position of column for state if any"
  method_option :keys_column,  :type => :numeric, :aliases => "-k", :desc => "Position of column for keys"
  method_option :default_lang, :type => :string, :aliases => "-l", :desc => "Default language to use for empty values if any"
  method_option :default_path, :type => :string, :aliases => "-p", :desc => "Path of output files"
  def csv2strings
    unless options.has_key?(:filename)
      puts "No value provided for required options '--filename'"
      exit
    end
    unless options.has_key?(:langs)
      puts "No value provided for required options '--langs'"
      exit
    end
	  args = options.dup
  	args.delete(:langs)
    args.delete(:filename)
  	converter = CSV2Strings::Converter.new(options[:filename], options[:langs], args)
  	converter.csv_to_dotstrings    
  end

  desc "FILENAMES", "convert '.strings' files to CSV file"
  method_option :filenames, :type => :array, :aliases => "-i", :desc => "location of strings files (FILENAMES)"
  method_option :csv_filename, :type => :string, :aliases => "-o", :desc => "location of output file"
  method_option :headers, :type => :array, :aliases => "-h", :desc => "override headers of columns, default is name of input files and 'Variables' for reference"
  method_option :dryrun, :type => :boolean, :aliases => "-n", :desc => "prints out content of hash without writing file"
  def strings2csv
    converter = Strings2CSV::Converter.new(options)
  	debug_values = converter.dotstrings_to_csv(!options[:dryrun])
    puts debug_values.inspect if options[:dryrun]   
  end

  private
  def options
    original_options = super
    return original_options unless File.exists?(".csvconverter")
    defaults = ::YAML::load_file(".csvconverter") || {}
    # add default values for options here
    defaults["csv_filename"] = "translations.csv" unless defaults.has_key?("csv_filename")
    defaults["dryrun"] = false unless defaults.has_key?("dryrun")
    defaults["keys_column"] = 0 unless defaults.has_key?("keys_column")
    Thor::CoreExt::HashWithIndifferentAccess.new(defaults.merge(original_options))  
  end
end