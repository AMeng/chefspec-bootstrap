Gem::Specification.new do |s|
  s.name        = 'chefspec-bootstrap'
  s.version     = '0.0.4'
  s.date        = '2014-12-01'
  s.summary     = 'Bootstrap your ChefSpec tests.'
  s.description = 'Automatically generate ChefSpec tests based on your recipes.'
  s.authors     = ['Alexander Meng']
  s.email       = 'alexbmeng@gmail.com'
  s.files       = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.homepage    = 'http://rubygems.org/gems/chefspec-bootstrap'
  s.license     = 'Apache'
  s.executables   = ['chefspec-bootstrap']
  s.required_ruby_version = '>= 1.9'

  s.add_dependency 'chefspec', '~> 3.4.0'
end
