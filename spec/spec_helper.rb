require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

RSpec.configure do |config|
  config.cookbook_path = ['spec/cookbooks']
  config.raise_errors_for_deprecations!
end
