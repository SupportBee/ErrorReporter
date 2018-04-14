require 'rspec'
require './lib/error-reporter'

RSpec.configure do |config|
  config.mock_with :flexmock
end

alias doing lambda
