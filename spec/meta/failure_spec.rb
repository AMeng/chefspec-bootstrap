require 'chefspec'
require_relative '../spec_helper'

describe 'spec::failure' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  it 'runs successfully' do
    expect { chef_run }.to raise_error
  end
end
