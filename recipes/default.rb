apt_repository 'transmission' do
  uri node[:transmission][:apt][:uri]
end

package 'transmission'

template '/etc/default/transmission-daemon' do
  source 'transmission-daemon.default.erb'
  owner 'root'
  group 'root'
  mode 0644
end

template '/etc/init/transmission-daemon.conf' do
  source 'transmission-daemon.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
end

template '/etc/init.d/transmission-daemon' do
  source 'transmission-daemon.init.erb'
  owner 'root'
  group 'root'
  mode 0755
end

service 'transmission' do
  service_name 'transmission-daemon'
  supports restart: true, reload: true
end

file '/etc/transmission-daemon/settings.json' do
  content JSON.generate(node[:transmission][:settings], indent: '    ', space: ' ', object_nl: "\n").gsub(/,$/, ',')
  owner node[:transmission][:user]
  group node[:transmission][:group]
  mode 0600
  notifies :reload, 'service[transmission]', :immediate
end
