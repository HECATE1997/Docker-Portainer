#!/bin/bash

set -e

echo ">>> Updating package list..."
sudo apt update

echo ">>> Removing old Docker packages..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do apt-get remove $pkg; done

# Add Docker's official GPG key:
apt -y install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

echo ">>> Installing Docker..."
apt  install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo ">>> Docker installation completed successfully."

usermod -aG docker $USER

echo ">>> Installing Portainer..."
# Install Portainer
docker volume create portainer_data

docker run -d -p 8000:8000 -p 9000:9000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts


echo ">>> To manage Docker, use the command 'docker' or access Portainer at http://localhost:9000"
echo ">>> For more information, visit https://docs.docker.com/engine/install/ubuntu/"