# create group
group node['group']

# give group sudo privileges
bash "give group sudo privileges" do
  code <<-EOH
    sed -i '/%#{node['group']}.*/d' /etc/sudoers
    echo '%#{node['group']} ALL=(ALL) NOPASSWD:ALL ' >> /etc/sudoers
  EOH
  not_if "grep -xq '%#{node['group']} ALL=(ALL) NOPASSWD:ALL ' /etc/sudoers"
end

# create user
user node['user']['name'] do
  gid node['group']
  home "/home/#{node['user']['name']}"
  password node['user']['password']
  shell '/bin/bash'

  # command deprecated in newer version of chef, replaced with `manage_home`
  #supports manage_home: true # need for /home creation
  
  manage_home true
end


