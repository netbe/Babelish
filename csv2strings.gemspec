puts RUBY_VERSION
Gem::Specification.new do |s|
  s.name        = 'csv2strings'
  s.version     = '0.2.1'
  s.date        = '2013-10-08'
  s.summary     = "CSV to iOS Localizable.strings converter"
  s.description = "ruby script converts a CSV file of translations to Localizable.strings files and vice-versa"
  s.authors     = ["François Benaiteau"]
  s.email       = 'francois.benaiteau@gmail.com'
  s.homepage    = 'https://github.com/netbe/CSV-to-iOS-Localizable.strings-converter'
  s.license = 'MIT'  
  
  s.add_dependency "thor"


  if RUBY_VERSION < '1.9'
    s.add_dependency "fastercsv"
    s.add_dependency "nokogiri", "= 1.5.10"
  end

  s.add_dependency "google_drive", '0.3.6'  
  s.add_development_dependency "rake"

  s.add_development_dependency "test-unit"
  s.add_development_dependency "simplecov"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path    = ['lib']
end