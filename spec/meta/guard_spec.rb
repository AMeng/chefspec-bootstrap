require 'chefspec'
require_relative '../spec_helper'

describe 'spec::guard' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs the guardable package' do
    expect(chef_run).to_not install_package('guardable')
  end

  it 'installs the unguardable package' do
    expect(chef_run).to install_package('unguardable')
  end
end
