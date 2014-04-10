module Babelish
  require 'thor'
  class Command < Thor
    include Thor::Actions
    class_option :verbose, :type => :boolean


    CSVCLASSES = %w{CSV2Strings CSV2Android CSV2JSON CSV2Php}

    CSVCLASSES.each do |classname|
      desc "#{classname.downcase}", "convert CSV file"
      method_option :filename, :type => :string, :desc => "CSV file (CSV_FILENAME) to convert from or name of file in Google Drive", :required => true
      method_option :langs, :type => :hash, :aliases => "-L", :desc => "Languages to convert. i.e. English:en", :required => true

      # optional options
      method_option :excluded_states, :type => :array, :aliases => "-x", :desc => "Exclude rows with given state"
      method_option :state_column, :type => :numeric, :aliases => "-s", :desc => "Position of column for state if any"
      method_option :keys_column,  :type => :numeric, :aliases => "-k", :desc => "Position of column for keys"
      method_option :default_lang, :type => :string, :aliases => "-l", :desc => "Default language to use for empty values if any"
      method_option :default_path, :type => :string, :aliases => "-p", :desc => "Path of output files"
      method_option :fetch, :type => :boolean, :desc => "Download file from Google Drive"
      define_method("#{classname.downcase}") do
        csv2base(classname)
      end
    end

    BASECLASSES = %w{Strings2CSV Android2CSV JSON2CSV Php2CSV}

    BASECLASSES.each do |classname|
      desc "#{classname.downcase}", "convert given files to CSV file"
      method_option :filenames, :type => :array, :aliases => "-i", :desc => "location of strings files (FILENAMES)", :required => true

      # optional options
      method_option :csv_filename, :type => :string, :aliases => "-o", :desc => "location of output file"
      method_option :headers, :type => :array, :aliases => "-h", :desc => "override headers of columns, default is name of input files and 'Variables' for reference"
      method_option :dryrun, :type => :boolean, :aliases => "-n", :desc => "prints out content of hash without writing file"
      define_method("#{classname.downcase}") do
        base2csv(classname)
      end
    end

    desc "csv_download", "Download Google Spreadsheet containing translations"
    method_option :gd_filename, :type => :string, :required => :true, :desc => "File to download from Google Drive"
    method_option :output_filename, :type => :string, :desc => "Filepath of downloaded file"
    def csv_download
      download(options['gd_filename'], options['output_filename'])
    end

    no_tasks do
      def download(filename, output_filename = nil)
        gd = GoogleDoc.new
        if output_filename
          file_path = gd.download filename.to_s, output_filename
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

      def csv2base(classname)
        args = options.dup
        if options[:fetch]
          say "Fetching csv file #{options[:filename]} from Google Drive"
          filename = download(options[:filename])
          abort unless filename # no file downloaded
          args.delete(:fetch)
        else
          filename = options[:filename]
        end
        args.delete(:langs)
        args.delete(:filename)

        class_object = eval classname
        converter = class_object.new(filename, options[:langs],args)
        say converter.convert
      end

      def base2csv(classname)
        class_object = eval classname
        converter = class_object.new(options)

        debug_values = converter.convert(!options[:dryrun])
        say debug_values.inspect if options[:dryrun]
      end
    end

    private
    def options
      original_options = super
      return original_options unless File.exists?(".babelish")
      defaults = ::YAML::load_file(".babelish") || {}
      Thor::CoreExt::HashWithIndifferentAccess.new(defaults.merge(original_options))
    end
  end
end
