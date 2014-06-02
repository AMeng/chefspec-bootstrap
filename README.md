chefspec-bootstrap
==================

A command line tool to get started with ChefSpec. The gem will look up all your recipes and create a spec file for each one.

```
gem install chefspec-bootstrap
chefspec-bootstrap
```

Options
---
```
--cookbooks-dir, -c <s>:   Your site cookbooks directory (default: site-cookbooks)
--spec-dir, -s <s>:        Your spec directory (default: spec)
--template, -t <s>:        ERB template file used to generate specs
```

Creating a custom template
---
A custom erb template can be passsed using the `-t` flag. See the included default template for an example.
