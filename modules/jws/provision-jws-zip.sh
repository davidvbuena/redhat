### Unzip Instances to Tomcat Path
sudo unzip /home/vagrant/jws-5.6.0-application-server.zip -d /etc/opt/rh/
sudo mv /etc/opt/rh/jws-5.6 /etc/opt/rh/jws-5.6-instance1
sudo cp -r /etc/opt/rh/jws-5.6-instance1 /etc/opt/rh/jws-5.6-instance2

sudo yum install unzip java-1.8.0-openjdk-devel -y

sudo cp /etc/opt/rh/jws-5.6-instance1/tomcat/conf/server.xml /etc/opt/rh/jws-5.6-instance1/tomcat/server.xml.backup

sudo cp /etc/opt/rh/jws-5.6-instance2/tomcat/conf/server.xml /etc/opt/rh/jws-5.6-instance2/tomcat/conf/server.xml.backup

### Config Certificates instance 2
sudo sed -in 's/<Service name="Catalina">/<Service name="Catalina">\n\n\n <!-- ### custom davidbuena conf --> \n<Connector port="9443" maxThreads="200" scheme="https" secure="true" SSLEnabled="true"\n\t\tprotocol="org.apache.coyote.http11.Http11AprProtocol"\n\t\tSSLCertificateFile="\/etc\/pki\/tls\/certs\/certificatejws5.crt"\n\t\tSSLCertificateKeyFile="\/etc\/pki\/tls\/private\/certificatejws5.key"\n\t\tSSLProtocol="TLSv1.2"\/>\n<!-- ### custom davidbuena conf -->/g' /etc/opt/rh/jws-5.6-instance2/tomcat/conf/server.xml

### Config Certificates instance 1
sudo sed -in 's/<Service name="Catalina">/<Service name="Catalina">\n\n\n <!-- ### custom davidbuena conf --> \n<Connector port="8443" maxThreads="200" scheme="https" secure="true" SSLEnabled="true"\n\t\tprotocol="org.apache.coyote.http11.Http11AprProtocol"\n\t\tSSLCertificateFile="\/etc\/pki\/tls\/certs\/certificatejws5.crt"\n\t\tSSLCertificateKeyFile="\/etc\/pki\/tls\/private\/certificatejws5.key"\n\t\tSSLProtocol="TLSv1.2"\/>\n<!-- ### custom davidbuena conf -->/g' /etc/opt/rh/jws-5.6-instance1/tomcat/conf/server.xml

### Proxy https:httpd apache -> http:jws tomcat
sudo sed -in 's/<\/VirtualHost>/\n### custom davidbuena conf \n### proxy to jws5\n\n\ProxyPreserveHost On\n\n\tProxyPassMatch\t\t\/(.*)$ http:\/\/127.0.0.1:9080\/$1\n\tProxyPassReverse\t\/(.*)$ http:\/\/127.0.0.1:9080\/$1\n\nServerName 127.0.0.1\n\n<\/VirtualHost>/g' /etc/httpd/conf.d/ssl.conf

### Proxy https:apache -> https:jws tomcat
sudo sed -in 's/ServerName 127.0.0.1/\tProxyPassMatch\t\t\/ssl https:\/\/127.0.0.1:9443\/$1\n\tProxyPassReverse\t\/ssl https:\/\/127.0.0.1:9443\/$1\n\nServerName 127.0.0.1\n\n/g' /etc/httpd/conf.d/ssl.conf

### creating rules to SSLProxyCheck
sudo sed -in 's/<\/VirtualHost>/<\/VirtualHost>\n### davidbuena sslproxy confs\nSSLProxyEngine on\nSSLProxyVerify none\nSSLProxyCheckPeerCN off\nSSLProxyCheckPeerName off/g' /etc/httpd/conf.d/ssl.conf

### saving backup conf
cat /etc/opt/rh/jws-5.6-instance1/tomcat/conf/server.xml > /etc/opt/rh/jws-5.6-instance2/tomcat/conf/server.xml.backup

sed -i 's/port="8080"/port="9080"/' /etc/opt/rh/jws-5.6-instance2/tomcat/conf/server.xml
sed -i 's/port="8443"/port="9443"/' /etc/opt/rh/jws-5.6-instance2/tomcat/conf/server.xml
sed -i 's/port="8005"/port="9005"/' /etc/opt/rh/jws-5.6-instance2/tomcat/conf/server.xml
sed -i 's/port="8009"/port="9009"/' /etc/opt/rh/jws-5.6-instance2/tomcat/conf/server.xml

sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --permanent --zone=public --add-port=9080/tcp
sudo firewall-cmd --permanent --zone=public --add-port=8443/tcp
sudo firewall-cmd --permanent --zone=public --add-port=9443/tcp
sudo firewall-cmd --reload

### starting 2 instances with same server
sudo /etc/opt/rh/jws-5.6-instance1/tomcat/bin/startup.sh
sudo /etc/opt/rh/jws-5.6-instance2/tomcat/bin/startup.sh

