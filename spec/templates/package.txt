require 'chefspec'
require_relative '../spec_helper'

describe 'spec::package' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs the defaultable package' do
    expect(chef_run).to install_package('defaultable')
  end

  it 'installs the identifiable package' do
    expect(chef_run).to install_package('identifiable')
  end

  it 'installs the installable package' do
    expect(chef_run).to install_package('installable')
  end

  it 'purges the purgeable package' do
    expect(chef_run).to purge_package('purgeable')
  end

  it 'reconfigs the reconfigurable package' do
    expect(chef_run).to reconfig_package('reconfigurable')
  end

  it 'removes the removeable package' do
    expect(chef_run).to remove_package('removeable')
  end

  it 'upgrades the upgradable package' do
    expect(chef_run).to upgrade_package('upgradable')
  end
end
