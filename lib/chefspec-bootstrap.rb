#!/usr/bin/env ruby

require 'erb'
require 'fileutils'
require 'ostruct'

module ChefSpec
  class Bootstrap
    def generate(cookbooks_dir, spec_dir, template_file)
      if not Dir.exist?(cookbooks_dir)
        abort "Unable to locate your cookbooks directory (#{cookbooks_dir})"
      end

      if not template_file
        template_file = root.join('templates', 'default.erb')
      end

      if not File.exist?(template_file)
        abort "Unable to locate template file (#{template_file})"
      end

      erb = ERB.new(File.read(template_file))

      Dir.glob("#{cookbooks_dir}/*/recipes/*").each do |path|
        path, recipe_file = File.split(path)
        recipe = recipe_file.split('.')[0]
        cookbook = path.split(File::SEPARATOR)[1]

        filename = "#{spec_dir}/#{cookbook}/#{recipe}_spec.rb"

        if not File.exist?(filename)
          FileUtils.mkdir_p "#{spec_dir}/#{cookbook}"

          puts "Creating spec file: #{filename}"

          File.open(filename, "w") do |spec_file|
            spec_file.write(erb.result(binding))
          end
        end
      end
    end

    def root
      @root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end
  end
end
