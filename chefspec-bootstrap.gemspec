Gem::Specification.new do |s|
  s.name        = 'chefspec-bootstrap'
  s.version     = '0.0.1'
  s.date        = '2014-06-02'
  s.summary     = "Bootstrap your ChefSpec tests."
  s.description = "Automatically generate ChefSpec tests based on your recipes."
  s.authors     = ["Alexander Meng"]
  s.email       = 'alexbmeng@gmail.com'
  s.files       = `git ls-files`.split($/)
  s.homepage    = 'http://rubygems.org/gems/chefspec-bootstrap'
  s.license     = 'Apache'
  s.executables   = ["chefspec-bootstrap"]
  s.required_ruby_version = '>= 1.9'

  s.add_dependency 'chef',     '~> 11.0'
  s.add_dependency 'chefspec', '~> 3.1.0'
  s.add_dependency 'trollop', '~> 2.0.0'
end
