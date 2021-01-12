
# Setup and enable nginx
dnf -y install @nginx yum-utils -y
systemctl start nginx
systemctl enable nginx

# Allow HTTP
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --reload

# We need to make sure we create a new drive/mount point at this point to create /data

# Create the repo folder in /data
mkdir -p /data/repos/

# Mount VMware share if you have it
# mount -t fuse.vmhgfs-fuse -o allow_other .host:/CentOSRepo /data/repos

# Write out the repo sync file
cat << EOF >> /etc/cron.daily/update-repo
#!/bin/bash

VER='8'
ARCH='x86_64'
REPOS=(BaseOS AppStream extras)

for REPO in ${REPOS[@]}
do
    reposync -p /data/repos/centos/${VER}/${ARCH}/os/ --repo=${REPO} --download-metadata --newest-only
done
EOF

# Make the file executable
chmod 755 /etc/cron.daily/update-repo


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

# Perform rsync
reposync -p /data/repos/centos/8/x86_64/os/ --repo=baseos --download-metadata --newest-only
reposync -p /data/repos/centos/8/x86_64/os/ --repo=appstream --download-metadata --newest-only
reposync -p /data/repos/centos/8/x86_64/os/ --repo=extras --download-metadata --newest-only
