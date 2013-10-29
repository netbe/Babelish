require "google_drive"
class GoogleDoc
  attr_accessor :session

  def authenticate
    # will try to get token from ~/.ruby_google_drive.token
    @session = GoogleDrive.saved_session
  end

  def download(requested_filename, worksheet_index, output_filename = "translations.csv")
    unless @session
      self.authenticate
    end
    result = @session.file_by_title(requested_filename)
    if result.is_a? Array
      file = result.first
    else
      file = result
    end
    return nil unless file
    file.export_as_file(output_filename, "csv", worksheet_index)
    return output_filename
  end

end