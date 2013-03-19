#!/usr/bin/env ruby
require 'net/http'
require "uri"

require "rubygems"
begin
       require "google_drive"
rescue LoadError
       puts "Failed to load google_drive"
       puts "gem install google_drive"
       exit
end


def list_files
    # Gets list of remote files.
    for file in session.files
      p file.title
    end
end

def prompt(*args)
    print(*args)
    gets
end

def token_from_google_authorize
  # (create oauth2 tokens from Google Console)
  client_id = "600996203789-hfqda552hv98sq8ouejhfhuve3jqncv1.apps.googleusercontent.com"
  client_secret = "_6ddNfgVKM39xnnw4zFpsY0b"

  # (paste the scope of the service you want here)
  # e.g.: https://www.googleapis.com/auth/gan
  scope = "https://docs.google.com/feeds/"

  # gem install oauth2
  require 'oauth2'
  raise "Missing client_id variable" if client_id.to_s.empty?
  raise "Missing client_secret variable" if client_secret.to_s.empty?
  raise "Missing scope variable" if scope.to_s.empty?

  redirect_uri = 'https://localhost/oauth2callback'

  auth_client_obj = OAuth2::Client.new(client_id, client_secret, {:site => 'https://accounts.google.com', :authorize_url => "/o/oauth2/auth", :token_url => "/o/oauth2/token"})
  authorize_url = auth_client_obj.auth_code.authorize_url(:scope => scope, :access_type => "offline", :redirect_uri => redirect_uri, :approval_prompt => 'force')
    # STEP 1
    puts "1) Paste this URL into your browser where you are logged in to the relevant Google account\n\n"
    puts authorize_url

    # STEP 2
    puts "\n\n\n2) Accept the authorization request from Google in your browser:"

    # STEP 3
    puts "\n\n\n3) Google will redirect you to localhost, but just copy the code parameter out of the URL they redirect you to, paste it here and hit enter:\n"
    code = gets.chomp.strip


    access_token_obj = auth_client_obj.auth_code.get_token(code, { :redirect_uri => redirect_uri, :token_method => :post })
    # STEP 4
    puts "Token is: #{access_token_obj.token}"
    puts "Refresh token is: #{access_token_obj.refresh_token}"
    puts "\n\n\nNow you can make API requests with the following api_access_token_obj variable!\n"
    puts "api_client_obj = OAuth2::Client.new(client_id, client_secret, {:site => 'https://www.googleapis.com'})"
    puts "api_access_token_obj = OAuth2::AccessToken.new(api_client_obj, '#{access_token_obj.token}')"
    puts "api_access_token_obj.get('some_relative_path_here') OR in your browser: http://www.googleapis.com/some_relative_path_here?access_token=#{access_token_obj.token}"
    puts "\n\n... and when that access_token expires in 1 hour, use this to refresh it:\n"
    puts "refresh_client_obj = OAuth2::Client.new(client_id, client_secret, {:site => 'https://accounts.google.com', :authorize_url => '/o/oauth2/auth', :token_url => '/o/oauth2/token'})"
    puts "refresh_access_token_obj = OAuth2::AccessToken.new(refresh_client_obj, '#{access_token_obj.token}', {refresh_token: '#{access_token_obj.refresh_token}'})"
    puts "refresh_access_token_obj.refresh!"    
  return access_token_obj.token
end

#######################
if $0 == __FILE__
  # TODO: make it to parameter
  requested_filename = "myapp_ios_localized_strings"
  output_filename = "resources/translations.csv"
  script = "./convert.rb #{output_filename}"

  token = ARGV[0]
  token = token_from_google_authorize unless token

  session = GoogleDrive.login_with_oauth(token)


   # download file
   file = session.file_by_title(requested_filename)
   file.export_as_file(output_filename,"csv")
   puts "file exported as #{output_filename}"
   system(script)
   puts ">> Moving file to right location"
   system("mv resources/de.lproj/Localizable.strings resources/myApp.strings")

   # cleanup
   #system("rm -f #{output_filename}")
end