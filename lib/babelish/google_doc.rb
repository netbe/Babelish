module Babelish
  # Faraday is a dependency of google_drive, this silents the warning
  # see https://github.com/CocoaPods/CocoaPods/commit/f33f967427b857bf73645fd4d3f19eb05e9be0e0
  # This is to make sure Faraday doesn't warn the user about the `system_timer` gem missing.
  old_warn, $-w = $-w, nil
  begin
    require "google_drive"
    Google::Apis::RequestOptions.default.retries = 5
  ensure
    $-w = old_warn
  end

  class GoogleDoc
    attr_accessor :session

    def download(requested_filename)
      file = file_with_name(requested_filename)
      return [] unless file
      files = []
      file.worksheets.each_with_index do |worksheet, index|
        files << download_spreadsheet(requested_filename, "translations_#{worksheet.title}.csv", index)
      end
      files
    end

    def download_spreadsheet(requested_filename, output_filename, worksheet_index = 0)
      output_filename ||= "translations.csv"
      spreadsheet = file_with_name(requested_filename)
      return nil unless spreadsheet
      worksheet = spreadsheet.worksheets[worksheet_index]
      worksheet.export_as_file(output_filename)
      return output_filename
    end

    def open(requested_filename)
      file = file_with_name(requested_filename)
      if file
        system "open \"#{file.human_url}\""
      else
        puts "can't open requested file"
      end
    end

    def authenticate
      # will try to get token and store in file below
      @session = GoogleDrive.saved_session ".babelish.token"
    end

    def file_with_name(name)
      unless @session
        authenticate
      end
      @session.spreadsheet_by_title(name)
    end
  end
end
