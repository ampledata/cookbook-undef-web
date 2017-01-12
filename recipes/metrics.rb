
include_recipe 'chef_nginx'


server_name = 'metrics.undef.net'
web_root = "/srv/#{server_name}/web_root"
nginx_config = [server_name, 'conf'].join('.')
site_template = File.join(
  node['nginx']['dir'], 'sites-available', nginx_config)


directory web_root do
  recursive true
end

template site_template do
  source 'nginx_graphite_site.erb'
  variables(
    :upstream_server => '127.0.0.1:3031',
    :server_name => server_name,
    :root => web_root
  )
  notifies :reload, resources(:service => 'nginx')
end

nginx_site nginx_config do
  enable false
end

nginx_site 'default' do
  enable false
end
