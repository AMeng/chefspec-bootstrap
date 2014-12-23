require 'chefspec'
require_relative '../lib/chefspec_bootstrap'
require_relative 'spec_helper'

describe 'Bootstrap' do
  Dir.entries('spec/cookbooks/spec/recipes').select { |d| d.end_with?('.rb') }.each do |recipe|
    it "creates the expected spec file for #{recipe}" do
      bootstrap = ChefSpec::Bootstrap.new("spec/cookbooks/spec/recipes/#{recipe}", nil, nil, nil, nil)
      template = File.open("spec/templates/#{recipe}", 'rb').read

      expect { bootstrap.generate }.to output(template).to_stdout
    end
  end
end
