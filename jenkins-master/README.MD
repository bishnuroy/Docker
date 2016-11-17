
#JENKINS DOCKER SETUP:

**Create Jenkins Image:**

  a) Create Folder
      # mkdir /jenkins
      
  b) Copy "Dockerfile", "config.xml", "docker.repo" and "start-jenkins.sh" to "/jenkins" folder.

  c) Execute command to create docker image.
  
      $ docker build -t solrreg.***.com/jenkins:latest .

