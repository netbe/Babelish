Gem::Specification.new do |s|
  s.name        = 'csv2strings'
  s.version     = '0.2.3'
  s.date        = '2013-12-11'
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
    s.add_dependency "google_drive", '0.3.6'
    s.add_dependency "orderedhash"
  else
    s.add_dependency "google_drive"
  end

  # google_drive dependency to ask for mail and password
  s.add_dependency "highline"

  s.add_development_dependency "rake"

  s.add_development_dependency "test-unit"
  s.add_development_dependency "simplecov"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path  = 'lib'
end
