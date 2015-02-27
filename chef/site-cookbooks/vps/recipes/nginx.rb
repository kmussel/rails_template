# template "/etc/monit/conf.d/nginx.conf" do 
#   source "nginx.monit.erb" 
#   owner node[:owner_name] 
#   group node[:owner_name] 
#   mode 0644 
#   variables({ 
#     :app_name => app_name, 
#     :user => node[:owner_name], 
#     :flavor => flavor
#   })
# end


