require_relative '../lib/chefspec_bootstrap'
require_relative 'spec_helper'

describe 'Bootstrap' do
  recipes = Dir.entries('spec/cookbooks/spec/recipes').map do |file|
    file.scan(/(.*).rb/).last.first if file.end_with?('.rb')
  end.compact

  recipes.each do |recipe|
    it "creates the expected spec file for #{recipe}" do
      bootstrap = ChefSpec::Bootstrap.new("spec/cookbooks/spec/recipes/#{recipe}.rb", nil, nil, nil, nil)
      spec = File.open("spec/meta/#{recipe}_spec.rb", 'rb').read

      expect { bootstrap.generate }.to output(spec).to_stdout
    end
  end
end
