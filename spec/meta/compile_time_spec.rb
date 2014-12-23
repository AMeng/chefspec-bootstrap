require 'chefspec'
require_relative '../spec_helper'

describe 'spec::compile_time' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs the compileable package' do
    expect(chef_run).to install_package('compileable').at_compile_time
  end
end
