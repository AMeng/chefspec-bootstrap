#!/usr/bin/env ruby

require 'fileutils'
require 'erb'

COOKBOOKS_DIR = 'site-cookbooks'
SPEC_DIR      = 'spec'

template = <<EOF
require 'chefspec'

describe '%{cookbook}::%{recipe}' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'runs successfully' do
    #expect{chef_run}.not_to raise_error
  end
end
EOF

if not Dir.exist?(COOKBOOKS_DIR)
  abort "Unable to locate your cookbooks directory (#{COOKBOOKS_DIR})"
end

Dir.glob("#{COOKBOOKS_DIR}/*/recipes/*").each do |path|
  path, recipe_file = File.split(path)
  recipe = recipe_file.split('.')[0]
  cookbook = path.split(File::SEPARATOR)[1]

  spec_filename = "#{SPEC_DIR}/#{cookbook}/#{recipe}_spec.rb"
  if not File.exist?(spec_filename)
    FileUtils.mkdir_p "#{SPEC_DIR}/#{cookbook}"

    puts "Creating spec file: #{spec_filename}"

    File.open(spec_filename, "w") do |spec_file|
      spec_file.write(template % {cookbook: cookbook, recipe: recipe})
    end
  end
end
