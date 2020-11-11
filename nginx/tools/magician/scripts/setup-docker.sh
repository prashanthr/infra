#!/bin/bash
# Docker setup
# https://docs.docker.com/engine/install/ubuntu/
echo "Setting up docker..."
# Remove old docker versions
sudo apt-get remove docker docker-engine docker.io containerd runc
# Install using convenience script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
# Change the docker user
# sudo usermod -aG docker docker-user
# Run the hello world image to test
sudo docker run hello-world
