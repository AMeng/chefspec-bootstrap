package 'multiactionable' do
  action [:install, :upgrade, :purge]
end

package 'mixactionable' do
  action [:upgrade, :purge]
end.run_action(:install)
