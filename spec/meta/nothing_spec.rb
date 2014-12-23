require 'chefspec'
require_relative '../spec_helper'

describe 'spec::nothing' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs the actionable package' do
    expect(chef_run).to install_package('actionable')
  end

  it 'ignores the unactionable package' do
    expect(chef_run.package('unactionable')).to do_nothing
  end
end
