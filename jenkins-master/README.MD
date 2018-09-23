
#JENKINS DOCKER SETUP: 

Updated  Dockerfile is here "https://github.com/bishnuroy/Jenkins"

**Create Jenkins Image:**

  a) Create Folder
      # mkdir /jenkins
      
  b) Copy "Dockerfile", "config.xml", "docker.repo" and "start-jenkins.sh" to "/jenkins" folder.

  c) Execute command to create docker image.
  
      $ docker build -t solrreg.***.com/jenkins:latest .
      
      **Taging The Docker Image:**
      
      $ docker tag ceb8131e4945(docker-image-ID) solrreg.***.com/jenkins:latest .
      $docker push solrreg.***.com/jenkins:latest .
      
 
 **Run Docker Container in Kubernatis Cluster:
 
      kubectl --server=(kub-master-server):8080 --namespace=NAMESPACE create -f jenkins-cluster.yaml
    
    Check Container:
      
      kubectl --server=(kub-master-server):8080 --namespace=NAMESPACE get pods
      kubectl --server=(kub-master-server):8080 --namespace=NAMESPACE get service
      kubectl --server=(kub-master-server):8080 --namespace=NAMESPACE get rc
      kubectl --server=(kub-master-server):8080 --namespace=NAMESPACE describe pod (podName)
      kubectl --server=(kub-master-server):8080 --namespace=NAMESPACE describe service (serviceName)
  
  
  Command To access The Container in kub-Cluster:
    
      
      kubectl --server=(kub-master-server):8080 --namespace=NAMESPACE exec -ti (container-name) -- bash


or you can run:

docker run -d --name jenkins-master -it -p 8081:8081 -v /var/lib/jenkins:/var/lib/jenkins:rw solrreg.***.com/jenkins:latest
