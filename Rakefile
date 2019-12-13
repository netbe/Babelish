require "bundler/gem_tasks"
require 'rake/testtask'
require 'yard'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/babelish/**/test_*.rb']
  # t.warning = true
  t.verbose = true
end


task :generate_keys do
  f = File.open("lib/babelish/keys.rb", "w")
  f.puts <<-FOO
  module Babelish
    module Keys
      GOOGLE_DRIVE_CLIENT_SECRET = "#{ENV['google_drive_client_secret']}"
      GOOGLE_DRIVE_CLIENT_ID = "#{ENV['google_drive_client_id']}"
    end
  end
  FOO
  f.close
end

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  # t.options = ['--any', '--extra', '--opts']
end

task :default => :test
