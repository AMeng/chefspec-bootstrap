chefspec-bootstrap
==================

[![Gem Version](http://img.shields.io/gem/v/chefspec-bootstrap.svg)][gem]
[![Build Status](http://img.shields.io/travis/AMeng/chefspec-bootstrap.svg)][travis]
[![Code Climate](http://img.shields.io/codeclimate/github/AMeng/chefspec-bootstrap.svg)][codeclimate]

[gem]: https://rubygems.org/gems/chefspec-bootstrap
[travis]: http://travis-ci.org/AMeng/chefspec-bootstrap
[codeclimate]: https://codeclimate.com/github/AMeng/chefspec-bootstrap

A command line tool to get started with ChefSpec. Generates spec files for your untested recipes.

Given a cookbook called `my_cookbook` with a recipe called `my_recipe.rb`:
```ruby
package "apache2"

file "/etc/apache2/sites-available/default" do
  action :delete
end

template "/etc/apache2/sites-available/mysite" do
  source "mysite.conf.erb"
end
```

The command line tool will output the following to stdout:
```ruby
require 'chefspec'

describe 'my_cookbook::my_recipe' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it "installs the apache2 package" do
    expect(chef_run).to install_package("apache2")
  end

  it "deletes the /etc/apache2/conf.d/python.conf file" do
    expect(chef_run).to delete_file("/etc/apache2/conf.d/python.conf")
  end

  it "creates the /etc/apache2/sites-available/mysite template" do
    expect(chef_run).to create_template("/etc/apache2/sites-available/mysite")
  end
end
```

Getting Started
---
Install the gem
```
gem install chefspec-bootstrap
```

Run the command-line tool, pointing to a recipe:
```
chefspec-bootstrap my_cookbook/recipes/my_recipe.rb
```

Options
---
```
Usage: chefspec-bootstrap <recipe.rb> [options]
    -t, --template <file>            ERB template file used to generate specs
    -s, --spechelper <file>          spec_helper.rb file. By default, looks in spec/spec_helper.rb
    -o, --output <file>              File to output spec. Prints to stdout if not specified.
```

Creating a custom template
---
A custom erb template can be passsed using the `-t` flag. See the included default template for an example.

What this project is NOT:
---
This is not a replacement for writing ChefSpec tests. Rather, this is a way to get started when you have an entirely untested recipe.
