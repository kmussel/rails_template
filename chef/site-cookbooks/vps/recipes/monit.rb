monitrc "nginx" do
   template_cookbook 'vps'
   template_source 'nginx.monit.conf.erb'
end

monitrc "resque" do
   template_cookbook 'vps'
   template_source 'resque.monit.conf.erb'
end