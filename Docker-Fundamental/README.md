##Docker Fandamantal :


** REF: https://opensource.com/resources/what-docker


**What is Docker?**

Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. Containers allow a developer to package up an application with all of the parts it needs, such as libraries and other dependencies, and ship it all out as one package


**Who is Docker for?**

Docker is a tool that is designed to benefit both developers and system administrators, making it a part of many DevOps (developers + operations) toolchains. For developers, it means that they can focus on writing code without worrying about the system that it will ultimately be running on. It also allows them to get a head start by using one of thousands of programs already designed to run in a Docker container as a part of their application. For operations staff, Docker gives flexibility and potentially reduces the number of systems needed because of its small footprint and lower overhead.


#Docker Setup in 5 nodes (2 manager, 2 nodes, 1 consul)

    1) created "isadmin" user for docker setup.


**Install Engine on each node**

    1) Update the yum packages in all nodes.
    
         $ sudo yum update
     
    2) Run the installation script.
  ```  
         [isadmin@consul01 ~]$ curl -sSL https://get.docker.com/ | sh
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

[isadmin@consul01 ~]$
 ```             
    3)After install run below command in all node if you want to run docker with "isadmin" account
    
        $sudo usermod -aG docker isadmin
      
    4)Edit OPTIONS variable (consul01.techeidolon.com server we will use as a image registry server, we can used saparate server for Image Registry)
    
        [isadmin@consul01 ~]$ cat /
        etc/sysconfig/docker
        #-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock
        DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --insecure-registry=consul01.techeidolon.com"
        [isadmin@consul01 ~]$
        
    5)Start Docker in all node.
    
```
        [isadmin@consul01 ~]$ sudo systemctl start docker.service
        [isadmin@consul01 ~]$
        [isadmin@consul01 ~]$ sudo systemctl enable docker.service
            Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.

``` 


        

