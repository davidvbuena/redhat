user:admin
pass:redhat12345@

### give root adm permission to jboss user

useradd jboss
usermod --append -G jboss jboss
usermod --append -G root jboss

### start jboss

[root@rhel8-lab2 /]# locate standalone.sh
/opt/jboss-eap-7.0/bin/standalone.sh
[root@rhel8-lab2 /]# /opt/jboss-eap-7.0/bin/standalone.sh

### custom locate folder
	### creating folder and associate custom confs
	
cd /opt/jboss-eap-7.0/standalone

cp -r configuration deployments lib \
~/JB248/labs/custom-eap	

### allow alternative dir for server

cd /opt/jboss-eap-7.0/bin
./standalone.sh \
-Djboss.server.base.dir=/home/student/JB248/labs/custom-eap/

### try another instance on default conf [already in my case]
sudo -u jboss /opt/jboss-eap-7.0/bin/standalone.sh

cp -r configuration deployments lib /home/student/JB248/labs/standalone-instance

############## Configure JBoss EAP network interfaces and socket binding groups

mkdir /home/student/JB248/labs/configuring-profiles/configuration/


cd /opt/jboss-eap-7.0/bin

./standalone.sh \
-Djboss.server.base.dir=/home/student/JB248/labs/configuring-profiles/

### to configure ip for management console

./standalone.sh -bmanagement 127.0.0.1

############## Configuring JBoss EAP in Standalone Mode

mkdir /opt/jboss/
mkdir /opt/jboss/standalone
cd /opt/jboss-eap-7.0/standalone
### (doesn't work well because i need grant premission) ### sudo -u jboss cp -r configuration deployments lib /opt/jboss/standalone
cp -r configuration deployments lib /opt/jboss/standalone

### Starting 

cd /opt/jboss-eap-7.0/bin
### sudo -u jboss  ./standalone.sh -Djboss.server.base.dir=/opt/jboss/standalone/
### ./standalone.sh -Djboss.server.base.dir=/opt/jboss/standalone/ 
nohup ./standalone.sh -Djboss.server.base.dir=/opt/jboss/standalone/ > /opt/jboss/standalone/log/dbuena-exec.log &

### Configuring and Starting standalone2

mkdir /opt/jboss/standalone2
cd /opt/jboss-eap-7.0/standalone
cp -r configuration deployments lib /opt/jboss/standalone2

### Starting

/opt/jboss-eap-7.0/bin/standalone.sh \
-Djboss.server.base.dir=/opt/jboss/standalone2/ \
-Djboss.socket.binding.port-offset=10000

### Log Level Debug via console 

Access the Management Console at http://localhost:19990

Configuration > Subsystems > Logging  > View > HANDLER > Console > Attributes > Edit -> Change the Level from INFO to DEBUG. > Save

### to stop jboss 
press ctrl+c

############## Scripting Configuration and Deploying Applications
### Testing executing
mkdir /home/student/JB248/labs/executing-cli
cp -r  standalone-instance/ /home/student/JB248/labs/executing-cli

/opt/jboss-eap-7.0/bin/jboss-cli.sh
[disconnected /] embed-server --server-config=standalone-ha.xml
[standalone@embedded /] 

nohup ./standalone.sh > /opt/jboss-eap-7.0/standalone/log/dbuena-exec.log &

------------------------------------
### connecting direct on .sh command
./jboss-cli.sh --connect

### connecting with a disconnected instance
./jboss-cli.sh
[disconnected /] connect localhost:9990
[standalone@localhost:9990 /] /:read-resource

### separate levels
[standalone@localhost:9990 /] /interface=public:read-resource

### view all the configurations of the undertow subsystem
[standalone@localhost:9990 /] /subsystem=undertow/configuration=*:read-resource
### compare the output 
[standalone@localhost:9990 /] /subsystem=undertow:read-resource
[standalone@localhost:9990 /] /subsystem=undertow:read-resource(recursive=true)
### view all resources on the server
[standalone@localhost:9990 /] /:read-resource(recursive=true)
### Redirect the output
[standalone@localhost:9990 /] :read-resource(recursive=true) > /tmp/output.txt
### press TAB to see all options in jboss-cli
[standalone@localhost:9990 /]:product-info
### 
[standalone@localhost:9990 /] cd /subsystem=datasources
[standalone@localhost:9990 subsystem=datasources] ./
data-source  jdbc-driver  xa-data-source
### check commands
[standalone@localhost:9990 subsystem=datasources] ls
[standalone@localhost:9990 subsystem=datasources] pwd => /subsystem=datasources
### write-attribute operation can be used to modify a resource's attributes using the CLI
[standalone@localhost:9990 subsystem=datasources] cd /subsystem=datasources/data-source=ExampleDS
[standalone@localhost:9990 data-source=ExampleDS] :write-attribute\
(name=min-pool-size,value=5)
{"outcome" => "success"}

### verify the change occurred:
[standalone@localhost:9990 data-source=ExampleDS] :read-attribute (name=min-pool-size)
{
    "outcome" => "success",
    "result" => 5
}
### View the standalone.xml file of your instance (in the folder /home/student/JB248/labs/executing-cli/configuration/standalone.xml).
[standalone@localhost:9990 /] /path=files:add\
(path=/files,relative-to=user.home)

### Remove resources
[standalone@localhost:9990 data-source=ExampleDS] cd /path=files
[standalone@localhost:9990 path=files] :remove

### How prepare some configuration without changing the production environment. 

/opt/jboss-eap-7.0/bin/jboss-cli.sh
[disconnected /] embed-server
[standalone@embedded /] /system-property=course:add(value=JB248)
[standalone@embedded /] exit
### new system property
/opt/jboss-eap-7.0/standalone/configuration/standalone.xml 
...
  </extensions>
    <system-properties>
      <property name="course" value="JB248"/>
    </system-properties>
  <management>
...
### custom config
 
[root@rhel8-lab2 bin]# ./jboss-cli.sh
You are disconnected at the moment. Type 'connect' to connect to the server or 'help' for the list of supported commands.
[disconnected /] embed-server --server-config=my-config.xml --empty-config
[standalone@embedded /] /system-property=country:add(value=US)
{"outcome" => "success"}
[standalone@embedded /] exit
[root@rhel8-lab2 bin]# cat \
> /opt/jboss-eap-7.0/standalone/configuration/my-config.xml
<?xml version="1.0" ?>

<server xmlns="urn:jboss:domain:4.1">

    <system-properties>
        <property name="country" value="US"/>
    </system-properties>

</server>
[root@rhel8-lab2 bin]# 

###

