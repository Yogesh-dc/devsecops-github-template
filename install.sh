#!/bin/bash

set -e  # Stop on first error

echo "🔧 Updating system and installing Docker, Maven, OpenJDK, and Apache2..."
sudo apt-get update -y
sudo apt-get install -y docker.io maven openjdk-11-jdk apache2

echo "🚀 Starting Docker..."
sudo systemctl start docker
sudo systemctl enable docker

echo "🌐 Starting Apache2..."
sudo systemctl start apache2
sudo systemctl enable apache2
echo "🌐 Apache2 running at http://localhost (or EC2 public IP)"

echo "📦 Starting Nexus Repository Manager..."
sudo docker run -d -p 8081:8081 --name nexus sonatype/nexus3
sleep 30
echo "📦 Nexus running at http://localhost:8081"

echo "🔍 Starting SonarQube..."
sudo docker run -d -p 9000:9000 --name sonarqube sonarqube:lts
sleep 60
echo "🔍 SonarQube running at http://localhost:9000"

echo "🛠️ Building Java application using Maven..."
mvn clean package

echo "🐳 Building Docker image for the app..."
sudo docker build -t devsecops-app .

echo "🚀 Running app container on port 8080..."
sudo docker run -d -p 8080:8080 --name app devsecops-app

echo "✅ Setup complete."
echo "📍 App:        http://<EC2-IP>:8080"
echo "📍 SonarQube:  http://<EC2-IP>:9000"
echo "📍 Nexus:      http://<EC2-IP>:8081"
echo "📍 Apache2:    http://<EC2-IP>"
echo "🔗 Access your application and tools using the above URLs."
