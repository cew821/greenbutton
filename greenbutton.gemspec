Gem::Specification.new do |s|
  s.name        = 'greenbutton'
  s.version     = '0.0.2'
  s.date        = '2014-03-17'
  s.summary     = 'Ruby parser for the GreenButton data standard.'
  s.description = 'This parser programmatically creates a Ruby object from a GreenButton XML data file, using the Nokogiri XML parsing library. See https://collaborate.nist.gov/twiki-sggrid/bin/view/SmartGrid/GreenButtonSDK for more information on Green Button. It is under active development and participation is encouraged. It is not yet stable.'
  s.authors     = ['Charles Worthington', 'Eric Hulburd']
  s.email       = ['c.e.worthington@gmail.com','eric@arbol.org']
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/cew821/greenbutton'
  s.license     = 'MIT'

  s.add_dependency 'nokogiri', '~> 1.6'
  s.add_development_dependency 'bundler',     '~> 1.7'
  s.add_development_dependency 'pry',         '~> 0.10'
  s.add_development_dependency 'rspec',       '~> 3.1'
  s.add_development_dependency 'rspec-its',   '~> 1.0'
  s.add_development_dependency 'simplecov',   '~> 0.9'

  s.test_files  = Dir.glob('spec/*_spec.rb')
end
