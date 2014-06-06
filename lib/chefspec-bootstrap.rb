require 'erb'
require 'fileutils'
require 'ostruct'
require 'chefspec'
require_relative 'api_map'

module ChefSpec
  class Bootstrap

    def initialize(cookbooks_dir, spec_dir, template_file, recursive)
      @cookbooks_dir = cookbooks_dir
      @spec_dir = spec_dir
      @template_file = template_file
      @recursive = recursive
    end

    def setup
      if not Dir.exist?(@cookbooks_dir)
        abort "Unable to locate your cookbooks directory (#{@cookbooks_dir})"
      end

      if not @template_file
        @template_file = root.join('templates', 'default.erb')
      end

      if not File.exist?(@template_file)
        abort "Unable to locate template file (#{@template_file})"
      end

      @api_map = ChefSpec::APIMap.new.map
    end

    def generate
      setup()

      erb = ERB.new(File.read(@template_file))

      ::RSpec.configure { |config| config.cookbook_path = [@cookbooks_dir, 'cookbooks'] }

      Dir.glob("#{@cookbooks_dir}/*/recipes/*").each do |path|
        path, recipe_file = File.split(path)
        recipe = recipe_file.split('.')[0]
        cookbook = path.split(File::SEPARATOR)[1]

        filename = "#{@spec_dir}/#{cookbook}/#{recipe}_spec.rb"

        puts filename

        if File.exist?(filename)
          puts "    spec already exists. Skipping."
        else
          FileUtils.mkdir_p "#{@spec_dir}/#{cookbook}"

          puts "    executing recipe with ChefSpec..."
          chef_run = get_chef_run(cookbook, recipe)

          if chef_run
            puts "    execution suceeded. Creating spec file."
          else
            puts "    execution failed. Creating empty spec file."
          end

          resources = get_resources(chef_run, cookbook, recipe)
          test_cases = generate_test_cases(resources)

          File.open(filename, "w") do |spec_file|
            spec_file.write(erb.result(binding))
          end
        end
      end
    end

    def root
      @root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end

    def get_chef_run(cookbook, recipe)
      begin
        return ChefSpec::Runner.new.converge("#{cookbook}::#{recipe}")
      rescue
        return nil
      end
    end

    def get_resource_name(resource)
      return resource.name || resource.identity
    end

    def get_resources(chef_run, cookbook, recipe)
      if chef_run
        resources = chef_run.resource_collection.all_resources
        if @recursive
          return resources
        else
          return resources.select do |resource|
            resource.cookbook_name == cookbook.to_sym and resource.recipe_name == recipe
          end
        end
      else
        return []
      end
    end

    def generate_test_cases(resources)
      test_cases = []
      resources.each do |resource|
        verbs = resource.action
        if not verbs.respond_to?(:each)
          verbs = [verbs]
        end

        noun = resource.resource_name
        adjective = resource.name

        verbs.each do |verb|
          if not verb == :nothing
            test_cases.push({
              :it => get_it_block(noun, verb, adjective),
              :expect => get_expect_block(noun, verb),
              :name => adjective
            })
          end
        end
      end
      return test_cases
    end

    def get_it_block(noun, verb, adjective)
      it = "%{verb}s the %{adjective} %{noun}"
      noun_readable = noun.to_s.gsub("_", " ")
      verb_readable = verb.to_s.gsub("_", " ")
      string_variables = {:noun => noun_readable, :verb => verb_readable, :adjective => adjective}

      if @api_map[noun] and @api_map[noun][:it]
        if @api_map[noun][:it][verb]
          it = @api_map[noun][:it][verb]
        elsif @api_map[noun][:it][:default]
          it = @api_map[noun][:it][:default]
        end
      end

      return escape_string(it  % string_variables)
    end

    def get_expect_block(noun, verb)
      expect = "%{verb}_%{noun}"
      string_variables = {:noun => noun, :verb => verb}

      if @api_map[noun] and @api_map[noun][:expect]
        if @api_map[noun][:expect][verb]
          expect = @api_map[noun][:expect][verb]
        elsif @api_map[noun][:expect][:default]
          expect = @api_map[noun][:expect][:default]
        end
      end

      return escape_string(expect % string_variables)
    end

    def escape_string(string)
      return string.gsub("\\","\\\\").gsub("\"", "\\\"")
    end

  end
end
