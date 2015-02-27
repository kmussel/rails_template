root = File.absolute_path(File.dirname(__FILE__))
file_cache_path root
cookbook_path    [root + "/../cookbooks", root + "/../site-cookbooks"]
node_path        root + "/../nodes"
role_path        root + "/../roles"
environment_path root + "/../environments"
data_bag_path    root + "/../data_bags"
#encrypted_data_bag_secret root + "/../data_bag_key"

# knife[:berkshelf_path] = root + "/../cookbooks"
knife[:berkshelf_path] = "cookbooks"

client_key              '/Users/kmussel/.ssh/id_rsa'

