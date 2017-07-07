Gem::Specification.new do |s|
  s.name          = 'error-reporter'
  s.version       = '0.1.0'
  s.date          = '2016-04-29'
  s.summary       = "Ruby class for reporting errors in SupportBee applications"
  s.description   = "Ruby class for reporting errors in SupportBee applications"
  s.authors       = ["Paulo Soares"]
  s.email         = 'paulo@supportbee.com'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
  s.homepage      = 'http://rubygems.org/gems/SupportBee-ErrorReporter'
  s.license       = 'MIT'

  s.add_dependency('honeybadger', ">= 3")
end
