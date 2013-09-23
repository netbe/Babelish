require "google_drive"
class GoogleDoc
  attr_accessor :session

  def authenticate
    # will try to get token from ~/.ruby_google_drive.token
    @session = GoogleDrive.saved_session
  end

  def download(requested_filename, output_filename = "translations.csv")
    unless @session
      self.authenticate
    end
    file = @session.file_by_title(requested_filename)
    file.export_as_file(output_filename,"csv")
    output_filename
  end

end