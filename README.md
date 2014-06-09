chefspec-bootstrap
==================

A command line tool to get started with ChefSpec. Generates spec files for your untested recipes.

Given a cookbook called `cookbook` with a recipe called `recipe.rb`:
```ruby
package "apache2"

file "/etc/apache2/sites-available/default" do
  action :delete
end

template "/etc/apache2/sites-available/mysite" do
  source "mysite.conf.erb"
end
```

The command line tool will generate the following spec file at `spec/cookbook/recipe_spec.rb`:
```ruby
require 'chefspec'

describe 'cookbook::recipe' do
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

Run the command-line tool
```
chefspec-bootstrap
```

Options
---
```
  --cookbooks-dir, -c <s>:   Your site cookbooks directory (default: site-cookbooks)
--cookbooks-path, -o <s+>:   RSpec config for cookbook path. Defaults to RSpec.configure.cookbook_path from spec_helper.rb.
          --recursive, -r:   Generate specs for included recipes.
       --spec-dir, -s <s>:   Your spec directory (default: spec)
       --template, -t <s>:   ERB template file used to generate specs
```

Creating a custom template
---
A custom erb template can be passsed using the `-t` flag. See the included default template for an example.
