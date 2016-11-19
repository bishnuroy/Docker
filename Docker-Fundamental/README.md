##Docker Fandamantal :


** REF: https://opensource.com/resources/what-docker


**What is Docker?**

Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. Containers allow a developer to package up an application with all of the parts it needs, such as libraries and other dependencies, and ship it all out as one package


**Who is Docker for?**

Docker is a tool that is designed to benefit both developers and system administrators, making it a part of many DevOps (developers + operations) toolchains. For developers, it means that they can focus on writing code without worrying about the system that it will ultimately be running on. It also allows them to get a head start by using one of thousands of programs already designed to run in a Docker container as a part of their application. For operations staff, Docker gives flexibility and potentially reduces the number of systems needed because of its small footprint and lower overhead.


#Docker Setup in 5 nodes (2 manager, 2 nodes, 1 consul)

    1) created "isadmin" user for docker setup.


**Install Engine on each nodes, managers and consul servers**

    1) Update the yum packages in all nodes.
    
         $ sudo yum update
     
    2) Run the installation script.
  ``` 
         [isadmin@node01 ~]$ curl -sSL https://get.docker.com/ | sh
         [sudo] password for isadmin:
          + sudo -E sh -c 'sleep 3; yum -y -q install docker-engine'
          warning: /var/cache/yum/x86_64/7/docker-main-repo/packages/docker-engine-selinux-1.12.3-1.el7.centos.noarch.rpm:      Header V4 RSA/SHA512 Signature, key ID 2c52609d: NOKEY
          Public key for docker-engine-selinux-1.12.3-1.el7.centos.noarch.rpm is not installed
          Importing GPG key 0x2C52609D:
          Userid     : "Docker Release Tool (releasedocker) <docker@docker.com>"
          Fingerprint: 5811 8e89 f3a9 1289 7c07 0adb f762 2157 2c52 609d
          From       : https://yum.dockerproject.org/gpg
          setsebool:  SELinux is disabled.

          If you would like to use Docker as a non-root user, you should now consider
          adding your user to the "docker" group with something like:

  sudo usermod -aG docker isadmin

Remember that you will have to log out and back in for this to take effect!

[isadmin@node01 ~]$
 ```             
    3)After install run below command in all node if you want to run docker with "isadmin" account
    
        $sudo usermod -aG docker isadmin
      
    4)Edit OPTIONS variable (consul01.techeidolon.com server we will use as a image registry server, we can used saparate server for Image Registry)
    
        [isadmin@node01 ~]$ cat /
        etc/sysconfig/docker
        #-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock
        DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --insecure-registry=consul01.techeidolon.com"
        [isadmin@node01 ~]$
        
    5)Start Docker in all node.
    
```
        [isadmin@node01 ~]$ sudo systemctl start docker.service
        [isadmin@node01 ~]$
        [isadmin@node01 ~]$ sudo systemctl enable docker.service
            Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.

``` 

   6)Verify that Docker Engine is installed correctly by running a container with the hello-world image.
            
            $ sudo systemctl enable docker.service
   
   ```
   [isadmin@node02 ~]$ sudo systemctl enable docker.service
Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
[isadmin@node02 ~]$ sudo docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world

c04b14da8d14: Pull complete
Digest: sha256:0256e8a36e2070f7bf2d0b0763dbabdd67798512411de4cdcf9431a1feb60fd9
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker Hub account:
 https://hub.docker.com

For more examples and ideas, visit:
 https://docs.docker.com/engine/userguide/

[isadmin@node02 ~]$
   ```
        
7)Run an Ubuntu, Centos, etc.. container with: 
  
    $ docker run -it ubuntu bash
    $ docker run -it centos bash



#Set up a discovery backend


1) login Console server and get the if of that server.
    
```
[root@consul01 ~]# ifconfig |grep inet
        inet 10.10.0.12  netmask 255.255.255.0  broadcast 10.10.0.255
        inet6 fe80::a00:27ff:fe41:7292  prefixlen 64  scopeid 0x20<link>
        inet 192.168.10.110  netmask 255.255.255.0  broadcast 192.168.10.255
        inet6 fe80::a00:27ff:fef5:3de0  prefixlen 64  scopeid 0x20<link>
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
[root@consul01 ~]#
```
*IP:*  192.168.10.110

2) Paste the launch command into the command line:
        
        $ docker run -d -p 8500:8500 --name=consul progrium/consul -server -bootstrap
        
```
[root@consul01 ~]# docker run -d -p 8500:8500 --name=consul progrium/consul -server -bootstrap
Unable to find image 'progrium/consul:latest' locally
latest: Pulling from progrium/consul
c862d82a67a2: Pull complete
0e7f3c08384e: Pull complete
0e221e32327a: Pull complete
09a952464e47: Pull complete
60a1b927414d: Pull complete
4c9f46b5ccce: Pull complete
417d86672aa4: Pull complete
b0d47ad24447: Pull complete
fd5300bd53f0: Pull complete
a3ed95caeb02: Pull complete
d023b445076e: Pull complete
ba8851f89e33: Pull complete
5d1cefca2a28: Pull complete
Digest: sha256:8cc8023462905929df9a79ff67ee435a36848ce7a10f18d6d0faba9306b97274
Status: Downloaded newer image for progrium/consul:latest
448288f62189a30a701e065bb4469473631d42f92d4acb55d93e5a068e01a235
[root@consul01 ~]#
```


3) Enter docker ps.

```
[root@consul01 ~]# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                                                                            NAMES
448288f62189        progrium/consul     "/bin/start -server -"   About a minute ago   Up About a minute   53/tcp, 53/udp, 8300-8302/tcp, 8400/tcp, 8301-8302/udp, 0.0.0.0:8500->8500/tcp   consul
[root@consul01 ~]#

```
        
#Create Swarm cluster

1) connect to the managers server and use ifconfig to get its IP address.

```
[root@manager01 ~]# ifconfig |grep inet
        inet 10.10.0.18  netmask 255.255.255.0  broadcast 10.10.0.255
        inet6 fe80::a00:27ff:fe5c:e7a7  prefixlen 64  scopeid 0x20<link>
        inet 192.168.10.101  netmask 255.255.255.0  broadcast 192.168.10.255
        inet6 fe80::a00:27ff:fe59:37e9  prefixlen 64  scopeid 0x20<link>
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
[root@manager01 ~]#
```
Manager01: 192.168.10.101
```
[root@manager02 ~]# ifconfig |grep inet
        inet 10.10.0.16  netmask 255.255.255.0  broadcast 10.10.0.255
        inet6 fe80::a00:27ff:fe35:c7f  prefixlen 64  scopeid 0x20<link>
        inet 192.168.10.102  netmask 255.255.255.0  broadcast 192.168.10.255
        inet6 fe80::a00:27ff:fe53:8459  prefixlen 64  scopeid 0x20<link>
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
[root@manager02 ~]#
```
Manager02: 192.168.10.102



2) To create the primary manager in a high-availability Swarm cluster, use the following syntax:

        $ docker run -d -p 4000:4000 swarm manage -H :4000 --replication --advertise <manager0_ip>:4000 consul://<consul0_ip>:8500
        
```
[root@manager01 ~]# docker run -d -p 4000:4000 swarm manage -H :4000 --replication --advertise 192.168.10.101:4000 consul://192.168.10.110:8500
Unable to find image 'swarm:latest' locally
latest: Pulling from library/swarm
220609e0bc51: Pull complete
b54bf338fe2f: Pull complete
d53aac5750d5: Pull complete
Digest: sha256:c9e1b4d4e399946c0542accf30f9a73500d6b0b075e152ed1c792214d3509d70
Status: Downloaded newer image for swarm:latest
9d0afea9262a3560d5e51bd6a6feef3927731b2e8d10205df203cf7e4b953507
[root@manager01 ~]#
```

3) Enter docker ps

```
[root@manager01 ~]# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                              NAMES
9d0afea9262a        swarm               "/swarm manage -H :40"   About a minute ago   Up About a minute   2375/tcp, 0.0.0.0:4000->4000/tcp   ecstatic_noyce
[root@manager01 ~]#
```

4) Start the secondary Swarm manager using following command.

```
[root@manager02 ~]# docker run -d -p 4000:4000 swarm manage -H :4000 --replication --advertise 192.168.10.102:4000 consul://192.168.10.110:8500
Unable to find image 'swarm:latest' locally
latest: Pulling from library/swarm
220609e0bc51: Pull complete
b54bf338fe2f: Pull complete
d53aac5750d5: Pull complete
Digest: sha256:c9e1b4d4e399946c0542accf30f9a73500d6b0b075e152ed1c792214d3509d70
Status: Downloaded newer image for swarm:latest
7b3c73307280ec7bb74945cdc67ac7603b2ed7326156d6581c0c18ba33677144
[root@manager02 ~]#
```

