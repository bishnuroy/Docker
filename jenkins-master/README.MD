
#JENKINS DOCKER SETUP:

**Create Jenkins Image:**

  a) Create Folder
      # mkdir /jenkins
      
  b) Copy "Dockerfile", "config.xml", "docker.repo" and "start-jenkins.sh" to "/jenkins" folder.

  c) Execute command to create docker image.
  
      $ docker build -t solrreg.***.com/jenkins:latest .
      
 
 Run Docker Container in Kubernatis Cluster:
 
  kubectl --server=(kub-master-server):8080 --namespace=NAMESPACE create -f namespace.yaml

