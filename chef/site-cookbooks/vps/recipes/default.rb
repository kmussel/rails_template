#
# Cookbook Name:: vps
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# update package database
execute "apt-get update"

# install packages
package "telnet"
package "postfix"
package "curl"
package "git-core"
package "zlib1g-dev"
package "libssl-dev"
package "libreadline-dev"
package "libyaml-dev"
package "libsqlite3-dev"
package "sqlite3"
package "libxml2-dev"
package "libxslt1-dev"
package "libpq-dev"
package "build-essential"
package "tree"

# set timezone
bash "set timezone" do
  code <<-EOH
    echo 'US/Pacific-New' > /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata
  EOH
  not_if "date | grep -q 'PDT\|PST'"
end

node.packages.each do |pkg|  
    package pkg
end

include_recipe 'build-essential::default'

# provision ssh
include_recipe 'openssh'

# NGINX STUFF

template "#{node.nginx.dir}/sites-available/#{node['app']['name']}" do
  source "nginx.conf.erb"
  mode "0644"
end

nginx_site "#{node['app']['name']}"

# UNICORN INIT SCRIPT

template "/etc/init.d/unicorn" do
  source "unicorn.init.erb"
  mode "0755"
end
