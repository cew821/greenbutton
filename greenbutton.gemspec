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

  s.test_files  = Dir.glob('spec/tc_*.rb')
end