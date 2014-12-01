require 'erb'
require 'fileutils'
require 'ostruct'
require 'chefspec'
require_relative 'api_map'

module ChefSpec
  class Bootstrap
    def initialize(recipe, template_file, spec_helper_file, output_file)
      @template_file = template_file
      @recipe = recipe
      @spec_helper_file = spec_helper_file || 'spec/spec_helper.rb'
      @output_file = output_file
    end

    def setup
      unless File.exist?(@recipe)
        abort "Unable to locate recipe file (#{@recipe})"
      end

      unless @template_file
        @template_file = root.join('templates', 'default.erb')
      end

      unless File.exist?(@template_file)
        abort "Unable to locate template file (#{@template_file})"
      end

      @api_map = ChefSpec::APIMap.new.map

      begin
        require File.expand_path(@spec_helper_file)
        @spec_helper = true
      rescue LoadError
        @spec_helper = false
        ::RSpec.configure do |config|
          config.cookbook_path = ['cookbooks']
        end
      end
    end

    def generate
      setup

      abort 'Output file already exists. Refusing to override.' if @output_file && File.exist?(@output_file)

      erb = ERB.new(File.read(@template_file))

      path, recipe_file = File.split(@recipe)
      recipe = recipe_file.split('.')[0]
      cookbook = path.split(File::SEPARATOR)[1]
      chef_run = get_chef_run(cookbook, recipe)

      puts 'Chefspec execution failed. Generating generic spec.' unless chef_run

      resources = get_resources(chef_run, cookbook, recipe)
      test_cases = generate_test_cases(resources)
      spec_helper = @spec_helper

      spec_output = erb.result(binding)

      if @output_file
        File.open(@output_file, 'w') do |spec_file|
          spec_file.write(spec_output)
        end
      else
        puts spec_output
      end
    end

    def root
      @root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end

    def get_chef_run(cookbook, recipe)
      return ChefSpec::Runner.new.converge("#{cookbook}::#{recipe}")
    rescue Exception => e
      return nil
    end

    def get_resource_name(resource)
      resource.name || resource.identity
    end

    def get_all_resources(chef_run)
      chef_run.resource_collection.all_resources
    end

    def get_resources(chef_run, cookbook, recipe)
      if chef_run
        resources = get_all_resources(chef_run)
        if @recursive
          return resources
        else
          return resources.select do |resource|
            resource.cookbook_name == cookbook.to_sym && resource.recipe_name == recipe
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
        unless verbs.respond_to?(:each)
          verbs = [verbs]
        end

        noun = resource.resource_name
        adjective = resource.name

        verbs.each do |verb|
          unless verb == :nothing
            test_cases.push(
              it: get_it_block(noun, verb, adjective),
              expect: get_expect_block(noun, verb),
              name: adjective
            )
          end
        end
      end
      test_cases
    end

    def get_it_block(noun, verb, adjective)
      it = '%{verb}s the %{adjective} %{noun}'
      noun_readable = noun.to_s.gsub('_', ' ')
      verb_readable = verb.to_s.gsub('_', ' ')
      string_variables = { noun: noun_readable, verb: verb_readable, adjective: adjective }

      if @api_map[noun] && @api_map[noun][:it]
        if @api_map[noun][:it][verb]
          it = @api_map[noun][:it][verb]
        elsif @api_map[noun][:it][:default]
          it = @api_map[noun][:it][:default]
        end
      end

      escape_string(it  % string_variables)
    end

    def get_expect_block(noun, verb)
      expect = '%{verb}_%{noun}'
      string_variables = { noun: noun, verb: verb }

      if @api_map[noun] && @api_map[noun][:expect]
        if @api_map[noun][:expect][verb]
          expect = @api_map[noun][:expect][verb]
        elsif @api_map[noun][:expect][:default]
          expect = @api_map[noun][:expect][:default]
        end
      end

      escape_string(expect % string_variables)
    end

    def escape_string(string)
      string.gsub('\\', '\\\\').gsub("\"", "\\\"")
    end
  end
end
