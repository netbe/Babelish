require 'bundler/gem_tasks'
require 'rake/testtask'
require 'yard'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/babelish/**/test_*.rb']
  # t.warning = true
  t.verbose = true
end

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  # t.options = ['--any', '--extra', '--opts']
end

task default: :test
