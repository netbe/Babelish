require 'test_helper'
class TestGoogleDoc < Test::Unit::TestCase


  # def test_authenticate_without_token
  #   system "rm .babelish.token"
  #   gd = Babelish::GoogleDoc.new
  #   assert_nothing_raised do
  #     VCR.use_cassette("auth_google_doc") do
  #       gd.authenticate
  #     end
  #   end
  # end

  # {"refresh_token":"1/UHxZJZhky4MIePnAKlDWpnol-P_rVDTYxNt3h92_ilRIgOrJDtdun6zK6XiATCKT"}

  # def test_authenticate_with_refresh_token
  #   gd = Babelish::GoogleDoc.new
  #   assert_nothing_raised do
  #     VCR.use_cassette("refresh_token") do
  #       gd.authenticate
  #     end
  #   end
  # end


  def test_download_my_strings
    gd = Babelish::GoogleDoc.new
    # assert_nothing_raised do
    #   VCR.use_cassette("refresh_token") do
    #     gd.authenticate
    #   end
    # end
    system 'echo {\"refresh_token\":\"fake_token\"} > .babelish.token'
    VCR.use_cassette("download_strings") do
      VCR.use_cassette("refresh_token") do
        gd.download "my_strings"
      end
    end

  end

end
