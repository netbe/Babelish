# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'babelish/version'

Gem::Specification.new do |s|
  s.name        = 'babelish'
  s.version     = Babelish::VERSION
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.summary     = "CSV converter for localization files"
  s.description = "This set of commands converts a CSV file to the following formats:
                  - .strings (iOS)
                  - .xml (Android)
                  - .json
                  - .php"
  s.authors     = ["François Benaiteau", "Markus Paeschke"]
  s.email       = ['francois.benaiteau@gmail.com', 'markus.paeschke@gmail.com']
  s.homepage    = 'http://netbe.github.io/Babelish/'
  s.license = 'MIT'

  s.add_dependency "thor"

  s.add_dependency "google_drive", "~> 2.1.12"
  s.add_dependency "nokogiri"
  # google_drive dependency to ask for mail and password
  s.add_dependency "highline"

  # specify version of rack so works on ruby <2.2.2
  s.add_dependency "rack", ">= 1.6.11"
  # json support
  s.add_dependency "json"

  s.add_development_dependency "rake"
  s.add_development_dependency "test-unit"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "yard"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path  = 'lib'
end
