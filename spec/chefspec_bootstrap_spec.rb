require_relative '../lib/chefspec_bootstrap'
require_relative 'spec_helper'

describe 'Bootstrap' do
  %w(failure directory package).each do |resource|
    it "creates the expected spec file for #{resource}" do
      bootstrap = ChefSpec::Bootstrap.new("spec/cookbooks/spec/recipes/#{resource}.rb", nil, nil, nil, nil)
      template = File.open("spec/templates/#{resource}.txt", 'rb').read

      expect { bootstrap.generate }.to output(template).to_stdout
    end
  end
end
