# Subscribe With Employe or Premmium User
sudo subscription-manager register --username "rhn-support-dbuena" --password 795NjB876
### Installing Dependencies
sudo echo -e "y" | sudo yum install httpd mod_ssl openssl apr unzip
### Creating Firewall Rules
#sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
#sudo firewall-cmd --permanent --zone=public --add-port=443/tcp
sudo firewall-cmd --reload
### Starting Apache 
#sudo systemctl start httpd 
sudo systemctl restart httpd
sudo systemctl restart sshd
