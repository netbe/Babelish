require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test_*.rb']
  # t.warning = true
  t.verbose = true
end

desc "Run tests"
task :default => :test
