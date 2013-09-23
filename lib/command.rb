$: << File.expand_path(File.join(File.dirname(__FILE__)))
require 'yaml'
require 'thor'
require 'csvconverter'

class Command < Thor

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