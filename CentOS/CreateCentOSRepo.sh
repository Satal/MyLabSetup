
# Setup and enable nginx
dnf -y install @nginx -y
systemctl start nginx
systemctl enable nginx

# Allow HTTP
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --reload

# We need to make sure we create a new drive/mount point at this point to create /data

# Create the repo folder in /data
mkdir -p /data/repos/centos/8/

# Write out the repo sync file
cat << EOF >> /etc/centos8_reposync.sh
#!/bin/bash
repos_base_dir="/data/repos/centos/8/"

# Start sync if base repo directory exist
if [[ -d "$repos_base_dir" ]] ; then
  # Start Sync
  rsync  -avSHP --delete rsync://mirror.liquidtelecom.com/centos/8/  "$repos_base_dir"

# Download CentOS 8 repository key
wget -P $repos_base_dir wget https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
EOF

# Make the file executable
chmod +x /etc/centos8_reposync.sh

# Run the script for the first time. This will take some time.
/etc/centos8_reposync.sh



# Configure nginx
cat << EOF >> /etc/nginx/conf.d/centos.conf
server {
	listen 80;
	server_name localhost;
        root /data/repos/;

       location / {
                autoindex on;
        }
}
EOF

# Set SELinux rules
sudo semanage fcontext -a -t httpd_sys_content_t "/data/repos(/.*)?"
sudo restorecon -Rv /data/repos

# Refresh and restart nginx
sudo nginx -t
sudo systemctl restart nginx
