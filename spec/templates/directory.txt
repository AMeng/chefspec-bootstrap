require 'chefspec'
require_relative '../spec_helper'

describe 'spec::directory' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'creates the defaultable directory' do
    expect(chef_run).to create_directory('defaultable')
  end

  it 'creates the identifiable directory' do
    expect(chef_run).to create_directory('identifiable')
  end

  it 'creates the creatable directory' do
    expect(chef_run).to create_directory('creatable')
  end

  it 'deletes the deletable directory' do
    expect(chef_run).to delete_directory('deletable')
  end
end
