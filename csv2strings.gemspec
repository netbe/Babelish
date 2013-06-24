Gem::Specification.new do |s|
  s.name        = 'csv2strings'
  s.version     = '0.2'
  s.date        = '2012-06-06'
  s.summary     = "CSV to iOS Localizable.strings converter"
  s.description = "ruby script converts a CSV file of translations to Localizable.strings files and vice-versa"
  s.authors     = ["François Benaiteau"]
  s.email       = 'francois.benaiteau@gmail.com'
  s.homepage    = 'https://github.com/netbe/CSV-to-iOS-Localizable.strings-converter'
  
  s.add_dependency "thor"
  s.add_dependency "fastercsv", :require => 'faster_csv' if RUBY_PLATFORM == 'ruby_19' 
  s.add_dependency "csv", :require => 'csv' if RUBY_PLATFORM == 'ruby_18'
  s.add_development_dependency "rake"
  s.add_development_dependency "mocha"
  s.add_development_dependency "test-unit"
  s.add_development_dependency "simplecov"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path    = ['lib']
end