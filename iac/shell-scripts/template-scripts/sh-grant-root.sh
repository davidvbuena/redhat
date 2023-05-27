sudo su -
echo -e "vagrant\nvagrant" | passwd root
    sed -in 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
	systemctl restart sshd
	service ssh restart

# Subscribe With Employe or Premmium User
sudo subscription-manager register --username "rhn-support-dbuena" --password 795NjB876
sudo yum update -y