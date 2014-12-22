package 'defaultable'

package 'identifiable' do
  package_name 'nameable'
end

package 'installable' do
  action :install
end

package 'purgeable' do
  action :purge
end

package 'reconfigurable' do
  action :reconfig
end

package 'removeable' do
  action :remove
end

package 'upgradable' do
  action :upgrade
end
