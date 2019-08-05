require "test_helper"
class TestFastlane < Test::Unit::TestCase
  def test_current_fastlane_compatibility
    system("mkdir tmp_fastlane")
    gemfile_content = <<-HEREDOC
    source "http://rubygems.org"
    gem 'fastlane', '2.126.0'
    gem 'babelish', path: '../..'
    HEREDOC

    gemfile_fullpath = "tmp_fastlane/Gemfile"
    File.write(gemfile_fullpath, gemfile_content, mode: "a")
    Dir.chdir("tmp_fastlane") do
      successful = system("bundle install")
      assert successful == true, "fastlane current version is not compatible"
    end
    system("rm -rf tmp_fastlane")
  end
end
