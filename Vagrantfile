
#### Loading Variables ####
guest_ip  = "192.168.8.87"
dirpath = __dir__
# host = __dir__.match(/[^\/]+.$/) ### hostname as a name of folder
host = "vm-vagrant-rhel8"
workpath = "C:\\genesis\\redhat\\cases\\2023"

#### Running Provision ####
Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |v|
    v.name = host
  end 

  config.vm.box = "generic/rhel8"
  config.vm.network "private_network", ip: guest_ip
### Provision Network+Firewall
config.vm.provision "shell", path: dirpath + "\\modules\\network\\setting-network.sh"  
### Provision HTTPD
  config.vm.provision "shell", path: dirpath + "\\modules\\httpd\\provision-httpd-yum.sh"
### Provision JWS
  config.vm.provision "shell", path: dirpath + "\\modules\\jws\\provision-jws-zip.sh"

  config.vm.synced_folder dirpath + "\\sync-folder", "/home/vagrant"
  config.vm.synced_folder workpath, "/home/cases"
  config.vm.network "public_network", bridge: "Intel(R) Wireless-AC 9560"
  config.vm.hostname = host
end