# create group
group node['group']

# provision user account
include_recipe 'user::data_bag'

# create user and add to group
user node['user']['name'] do
  gid node['group']
  home "/home/#{node['user']['name']}"
  password node['user']['password']
  shell "/bin/bash"
  supports manage_home: true # need for /home creation
end

# give group sudo privileges
bash "give group sudo privileges" do
  code <<-EOH
    sed -i '/%#{node['group']}.*/d' /etc/sudoers
    echo '%#{node['group']} ALL=(ALL) ALL' >> /etc/sudoers
  EOH
  not_if "grep -xq '%#{node['group']} ALL=(ALL) ALL' /etc/sudoers"
end

config = data_bag_item("users", "deploy")
#  
#  node['user']['name']
# template "/home/#{node['user']['name']}" do
# ...
#  variables(
#    :project_root =&gt; "#{config['deployment_dir']}/current",
#    :queue =&gt; config['resque_queues']
#  )
# end

template "/home/#{node['user']['name']}/.bash_profile_env" do
  variables :env => config['env'] 
  source "dot_profile.erb"
end

# file "/home/#{node['user']['name']}/.bash_profile_env" do
#   
#   content
# end

bash "insert_line" do
  user "deploy"
  code <<-EOS  
    echo "for f in ~/.bash_profile_*; do source $f; done" >> /home/#{node['user']['name']}/.bash_profile
  EOS
  not_if "grep -q 'for f in ~/.bash_profile_*; do source $f; done' /home/#{node['user']['name']}/.bash_profile"
end
