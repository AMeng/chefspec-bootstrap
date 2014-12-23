# rubocop:disable Lint/UselessComparison

package 'guardable' do
  not_if { 1 == 1 }
end

package 'unguardable' do
  only_if { 1 == 1 }
end
