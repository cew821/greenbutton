Gem::Specification.new do |s|
  s.name        = 'greenbutton'
  s.version     = '0.0.1'
  s.date        = '2014-03-17'
  s.summary     = "Ruby parser for GreenButton data standard."
  s.description = "This parser programmatically creates a Ruby object from a GreenButton data file. See https://collaborate.nist.gov/twiki-sggrid/bin/view/SmartGrid/GreenButtonSDK"
  s.authors     = ["Charles Worthington", "Eric Hulburd"]
  s.email       = ['c.e.worthington@gmail.com','eric@arbol.org']
  s.files       = ["lib/greenbutton.rb"]
  s.homepage    =
    'https://github.com/cew821/greenbutton'
  s.license       = 'MIT'

  s.add_dependency "nokogiri", "~>1.6.1"
  s.add_development_dependency "bundler", "~>1.5.1"
  s.add_development_dependency "rspec", "~>2.14.4"

  s.test_files  = Dir.glob('spec/*.rb')
end