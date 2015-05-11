ENV['RACK_ENV'] = 'test'

require 'pry'
require 'rspec/its'
require 'simplecov'

SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter]

SimpleCov.start do
  add_filter 'spec'
  coverage_dir 'docs/coverage'
end

require 'greenbutton'

Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.include GreenButtonHelper
  config.mock_framework = :rspec
  config.pattern = '**/*_spec.rb'
end
