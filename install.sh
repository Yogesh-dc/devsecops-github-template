
#!/bin/bash

# Update system and install Docker
sudo apt-get update -y
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Run Nexus
sudo docker run -d -p 8081:8081 --name nexus sonatype/nexus3

# Wait for Nexus to initialize
sleep 60

# Run SonarQube
sudo docker run -d -p 9000:9000 --name sonarqube sonarqube:lts

# Wait for SonarQube to initialize
sleep 60

# Run your Java app (assuming it’s built using Dockerfile)
sudo docker build -t devsecops-app .
sudo docker run -d -p 8080:8080 --name app devsecops-app
