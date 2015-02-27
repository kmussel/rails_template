default.packages = %w(vim git)

default['build-essential']['compile_time'] = true
default.users = ['deploy']  

# default['app']               = ''

# default['nodejs']['dir']     = '/usr/local'
# default['nodejs']['version'] = '0.10.29'

default['ruby']['version']   = '2.1.3'

default['postgresql']['enable_pgdg_apt'] = true
default['postgresql']['version'] = "9.3"
default['postgresql']['password'] = {"postgres" => "md5633bc3c3d823be2a52d3dff94031e2c2"}
default['postgresql']['config']['listen_addresses'] = "*"
default['postgresql']['pg_hba'] = [
  {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'peer'},  
  {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident'},
  {:type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'ident'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'md5'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '0.0.0.0/0', :method => 'md5'}  
]

default['postgresql']['database']['name'] = 'rails_template_production'