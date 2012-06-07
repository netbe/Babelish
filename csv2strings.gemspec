Gem::Specification.new do |s|
  s.name        = 'csv2strings'
  s.version     = '0.2'
  s.date        = '2012-06-06'
  s.summary     = "CSV to iOS Localizable.strings converter"
  s.description = "ruby script converts a CSV file of translations to Localizable.strings files and vice-versa"
  s.authors     = ["François Benaiteau"]
  s.email       = 'francois.benaiteau@gmail.com'
  s.homepage    = 'https://github.com/netbe/CSV-to-iOS-Localizable.strings-converte'
  s.files       = ["lib/csv2strings"]
  s.executables = "csv2strings"
  s.add_dependency "fastercsv"#, :require => 'faster_csv'
  # s.add_dependency "csv"
  s.require_path    = ['lib']
end