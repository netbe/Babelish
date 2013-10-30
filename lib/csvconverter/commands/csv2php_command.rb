require "csvconverter/command"
class CSV2PhpCommand < Command
  default_task :csv2php

  desc "CSV_FILENAME", "convert CSV file to php language file file"
  # required options but handled in method because of options read from yaml file
  method_option :filename, :type => :string, :desc => "CSV file (CSV_FILENAME) to convert from or name of file in Google Drive"
  method_option :fetch, :type => :boolean, :desc => "Download file from Google Drive"
  method_option :langs, :type => :hash, :aliases => "-L", :desc => "Languages to convert"
  # optional options
  method_option :excluded_states, :type => :array, :aliases => "-x", :desc => "Exclude rows with given state"
  method_option :state_column, :type => :numeric, :aliases => "-s", :desc => "Position of column for state if any"
  method_option :keys_column,  :type => :numeric, :aliases => "-k", :desc => "Position of column for keys"
  method_option :default_lang, :type => :string, :aliases => "-l", :desc => "Default language to use for empty values if any"
  method_option :default_path, :type => :string, :aliases => "-p", :desc => "Path of output files"
  def csv2php(filename = nil)
    unless filename || options.has_key?('filename')
      say "No value provided for required options '--filename'"
      help("csv2php")
      exit
    end
    
    filename ||= options['filename']
    if options['fetch']
      say "Downloading file from Google Drive"
      filename = invoke :csv_download, nil, {"gd_filename" => filename}
      exit unless filename
    end

    unless options.has_key?('langs')
      say "No value provided for required options '--langs'"
      help("csv2php")
      exit
    end
 
    args = options.dup
    args.delete(:langs)
    args.delete(:filename)
    converter = CSV2Php.new(filename, options[:langs], args)
    say converter.convert    
  end
end