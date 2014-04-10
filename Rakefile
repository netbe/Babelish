require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/babelish/**/test_*.rb']
  # t.warning = true
  t.verbose = true
end


task :default => :test
