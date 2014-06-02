#!/usr/bin/env ruby

require 'fileutils'
require 'erb'

SPEC_TEMPLATE = <<EOF
require 'chefspec'

describe '%{cookbook}::%{recipe}' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'runs successfully' do
    expect{chef_run}.not_to raise_error
  end
end
EOF

module ChefSpec
  class Bootstrap
    def generate(cookbooks_dir, spec_dir, template_file)
      # if not Dir.exist?(cookbooks_dir)
      #   abort "Unable to locate your cookbooks directory (#{cookbooks_dir})"
      # end

      if not template_file
        template_file = root.join('templates', 'default.erb')
      end

      if not File.exist?(template_file)
        abort "Unable to locate template file (#{template_file})"
      end

      # Dir.glob("#{cookbooks_dir}/*/recipes/*").each do |path|
      #   path, recipe_file = File.split(path)
      #   recipe = recipe_file.split('.')[0]
      #   cookbook = path.split(File::SEPARATOR)[1]

      #   filename = "#{spec_dir}/#{cookbook}/#{recipe}_spec.rb"

      #   if not File.exist?(filename)
      #     FileUtils.mkdir_p "#{spec_dir}/#{cookbook}"

      #     puts "Creating spec file: #{filename}"

      #     File.open(filename, "w") do |spec_file|
      #       spec_file.write(SPEC_TEMPLATE % {cookbook: cookbook, recipe: recipe})
      #     end
      #   end
      # end
    end

    def root
      @root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end
  end
end
