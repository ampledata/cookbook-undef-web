
include_recipe 'chef_nginx'


server_name = 'tomato.undef.net'

web_root = "/srv/#{server_name}/web_root"

nginx_config = [server_name, 'conf'].join('.')
site_template = File.join(
  node['nginx']['dir'], 'sites-available', nginx_config)


directory web_root do
  recursive true
end

template site_template do
  source 'nginx_site.erb'
  variables(
    :server_name => server_name,
    :root => web_root
  )
  notifies :reload, resources(:service => 'nginx')
end

nginx_site nginx_config

nginx_site 'default' do
  enable false
end
