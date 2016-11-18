# BUILD USING:  docker build --rm -t imahge-name/jenkins
# RUN USING: docker run -d --name jenkins-master -it -p 8081:8081 -v /var/lib/jenkins:/var/lib/jenkins:rw imahge-name/jenkins

FROM imagelocation/centos7

MAINTAINER Bishnu Ladla email:bishnuroy@gmail.com

# Add docker yum repository.
COPY docker.repo /etc/yum.repos.d/

# Install necessary packages.
RUN yum update -y && yum install wget -y && \
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo && \
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key && \
yum install jenkins java-1.8.0-openjdk initscripts maven ant git bind-utils docker-engine-1.9.1 docker-engine-selinux-1.9.1 -y &&\
yum clean all

# Copy startup script inside.
COPY start-jenkins.sh /start-jenkins.sh

# Start and Install plugins.
RUN /etc/init.d/jenkins start && sleep 30 && \
wget http://localhost:8080/jnlpJars/jenkins-cli.jar -O /usr/lib/jenkins/jenkins-cli.jar && \
java -jar /usr/lib/jenkins/jenkins-cli.jar -s http://localhost:8080 \
install-plugin git-client \
git \
docker-build-publish \
docker-build-step \
docker-plugin \
docker-commons \
docker-custom-build-environment \
ghprb \
workflow-aggregator \
workflow-api \
workflow-cps \
workflow-job \
workflow-basic-steps \
workflow-cps-global-lib \
workflow-step-api \
workflow-support \
workflow-scm-step \
workflow-durable-task-step \
job-import-plugin -deploy

RUN rm -rf /usr/lib/jenkins/jenkins-cli.jar

# Copy configuration (w3ID login enabled)
COPY config.xml /var/lib/jenkins/

# Change ownership to jenkins
RUN chown -R jenkins:jenkins /var/lib/jenkins/config.xml && \
chmod -R 755 /var/lib/jenkins/config.xml

# Changing group ID to 233 to match with CoreOS's Docker user.
RUN groupmod -g 233 docker && usermod -G docker jenkins

# Stop Jenkins server and backup jenkins home director
RUN /etc/init.d/jenkins stop && /usr/bin/tar -cpf /root/jenkins-home.tar /var/lib/jenkins > /dev/null

RUN rm -rf /var/log/jenkins/jenkins.log && ln -sf /dev/stdout /var/log/jenkins/jenkins.log

EXPOSE 8080

CMD /start-jenkins.sh && sleep 3650d
