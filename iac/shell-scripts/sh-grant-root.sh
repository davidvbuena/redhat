sudo su -
echo -e "vagrant\nvagrant" | passwd root
    sed -in 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
	systemctl restart sshd
	service ssh restart

# Subscribe With Employe or Premmium User
sudo subscription-manager register --username "rhn-support-dbuena" --password 795NjB876
# sudo subscription-manager repos --enable ansible-automation-platform-2.2-for-rhel-7-x86_64-rpms
# subscription-manager attach --pool=8a85f9a07db4828b017dc51ae7de0901
sudo yum update -y