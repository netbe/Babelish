require 'thor'
class Command < Thor
  include Thor::Actions
  class_option :verbose, :type => :boolean

  desc "csv_download", "Download Google Spreadsheet containing translations"
  method_option :gd_filename, :type => :string, :required => :true, :desc => "File to download from Google Drive"
  method_option :output_filename, :type => :string, :desc => "Filepath of downloaded file"
  def csv_download
    filename = options['gd_filename']
    gd = GoogleDoc.new
    if options['output_filename']
      file_path = gd.download filename.to_s, options['output_filename']      
    else
      file_path = gd.download filename.to_s
    end
    if file_path
      say "File '#{filename}' downloaded to '#{file_path}'"
    else
      say "Could not download the requested file: #{filename}"
    end
    file_path
  end
  
  private
  def options
    original_options = super
    return original_options unless File.exists?(".csvconverter")
    defaults = ::YAML::load_file(".csvconverter") || {}
    # add default values for options here
    defaults["csv_filename"] = "translations.csv" unless defaults.has_key?("csv_filename")
    defaults["dryrun"] = false unless defaults.has_key?("dryrun")
    defaults["fetch"] = false unless defaults.has_key?("fetch")
    defaults["keys_column"] = 0 unless defaults.has_key?("keys_column")
    Thor::CoreExt::HashWithIndifferentAccess.new(defaults.merge(original_options))  
  end
end
