require 'chefspec'
require_relative '../spec_helper'

describe 'spec::multiple_actions' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs the multiactionable package' do
    expect(chef_run).to install_package('multiactionable')
  end

  it 'upgrades the multiactionable package' do
    expect(chef_run).to upgrade_package('multiactionable')
  end

  it 'purges the multiactionable package' do
    expect(chef_run).to purge_package('multiactionable')
  end

  it 'installs the mixactionable package' do
    expect(chef_run).to install_package('mixactionable').at_compile_time
  end

  it 'upgrades the mixactionable package' do
    expect(chef_run).to upgrade_package('mixactionable')
  end

  it 'purges the mixactionable package' do
    expect(chef_run).to purge_package('mixactionable')
  end
end
