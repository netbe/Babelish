require "csvconverter/command"
class CSV2JSONCommand < Command
  default_task :csv2json

  desc "CSV_FILENAME", "convert CSV file to JSON file"
  # required options but handled in method because of options read from yaml file
  method_option :filename, :type => :string, :desc => "CSV file (CSV_FILENAME) to convert from or name of file in Google Drive"
  method_option :fetch, :type => :boolean, :desc => "Download file from Google Drive"
  method_option :gd_filename, :type => :string, :desc => "File to download from Google Drive"
  method_option :gd_worksheet_index, :type => :numeric, :desc => "Index of Google Drive Spreadsheet Worksheet"
  method_option :langs, :type => :hash, :aliases => "-L", :desc => "Languages to convert"
  # optional options
  method_option :output_file, :type => :string, :desc => "Filepath of output file"
  method_option :excluded_states, :type => :array, :aliases => "-x", :desc => "Exclude rows with given state"
  method_option :state_column, :type => :numeric, :aliases => "-s", :desc => "Position of column for state if any"
  method_option :keys_column,  :type => :numeric, :aliases => "-k", :desc => "Position of column for keys"
  method_option :default_lang, :type => :string, :aliases => "-l", :desc => "Default language to use for empty values if any"
  method_option :default_path, :type => :string, :aliases => "-p", :desc => "Path of output files"
  def csv2json(filename = nil)
    unless filename || options.has_key?('filename') || options.has_key?('gd_filename')
      say "No value provided for required options '--filename'"
      help("csv2json")
      exit
    end
    
    filename ||= options['filename']
    if options['fetch']
      say "Downloading file from Google Drive"
      filename = invoke :csv_download, nil, {"gd_filename" => options['gd_filename'], "worksheet_index" => options['gd_worksheet_index']}
      exit unless filename
    end

    unless options.has_key?('langs')
      say "No value provided for required options '--langs'"
      help("csv2json")
      exit
    end
 
    args = options.dup
    args.delete(:langs)
    args.delete(:filename)
    converter = CSV2JSON.new(filename, options[:langs], args)
    say converter.convert
    
    File.delete(filename)
  end

end
