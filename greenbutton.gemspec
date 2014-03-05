Gem::Specification.new do |s|
  s.name        = 'greenbutton'
  s.version     = '0.1'
  s.date        = '2014-02-26'
  s.summary     = 'GreenButton Parser'
  s.description = 'GreenButton data parser for Ruby'
  s.authors     = ['Charles Worthington']
  s.files       = %w(lib/greenbutton.rb lib/greenbutton/objectifier.rb) +
      %w(license.txt Readme.md)
  s.homepage    = 'https://github.com/cew821/greenbutton'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'nokogiri'
  s.require_path = 'lib'
end