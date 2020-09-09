# Remove PodMan
yum remove buildah skopeo podman containers-common atomic-registries docker -y

# Add docker repo
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

# Install docker
dnf install docker-ce --nobest -y

# Start docker service and set to start on boot
systemctl start docker
systemctl enable docker

# Install docker-compose
dnf install curl -y
curl -L "https://github.com/docker/compose/releases/download/1.27.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Link docker-compose to bin so it can be used from anywhere
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Configure firewall
firewall-cmd --permanent --zone=trusted --change-interface=docker0
firewall-cmd --add-masquerade --permanent
firewall-cmd --reload

# Add "admin" user to the Docker group so they don't need to sudo for all docker commands
# if this needs to be something other than the "admin" user then change the script accordingly
usermod -aG Docker admin
