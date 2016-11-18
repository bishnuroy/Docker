#FROM image-location/centos6
FROM centos:centos6
MAINTAINER Bishnu bishnuroy@gmail.com


# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mongodb && useradd -r -g mongodb mongodb
RUN yum -y update; yum clean all

RUN echo "[mongodb-org-3.2]" >>/etc/yum.repos.d/mongodb-org-3.2.repo
RUN echo "name=MongoDB Repository" >>/etc/yum.repos.d/mongodb-org-3.2.repo
RUN echo "baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.2/x86_64/" >>/etc/yum.repos.d/mongodb-org-3.2.repo
RUN echo "gpgcheck=1" >>/etc/yum.repos.d/mongodb-org-3.2.repo
RUN echo "enabled=1" >>/etc/yum.repos.d/mongodb-org-3.2.repo
RUN echo "gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc" >> /etc/yum.repos.d/mongodb-org-3.2.repo

RUN yum install -y mongodb-org

RUN mkdir -p /data/db /data/configdb \
        && chown -R mongodb:mongodb /data/db /data/configdb
VOLUME /data/db /data/configdb

ADD startup.sh /opt/
RUN chmod u+x /opt/startup.sh
ADD adduser.js /opt/

EXPOSE 27017
CMD ["/opt/startup.sh"]
