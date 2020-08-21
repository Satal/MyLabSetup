# Backup all the old repositories
mkdir /etc/yum.repos.d/old-repos
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/old-repos 

# Create the new repository file
cat << EOF >> /etc/yum.repos.d/local.repo
[BaseOS]
name=CentOS-$releasever - Base
baseurl=//repos.computingforgeeks.com/centos/$releasever/BaseOS/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=//repos.computingforgeeks.com/centos/$releasever/RPM-GPG-KEY-CentOS-Official

[AppStream]
name=CentOS-$releasever - AppStream
baseurl=//repos.computingforgeeks.com/centos/$releasever/AppStream/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=//repos.computingforgeeks.com/centos/$releasever/RPM-GPG-KEY-CentOS-Official

[centosplus]
name=CentOS-$releasever - Plus
baseurl=//repos.computingforgeeks.com/centos/$releasever/centosplus/$basearch/os/
gpgcheck=1
enabled=0
gpgkey=//repos.computingforgeeks.com/centos/$releasever/RPM-GPG-KEY-CentOS-Official

[extras]
name=CentOS-$releasever - Extras
baseurl=//repos.computingforgeeks.com/centos/$releasever/extras/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=//repos.computingforgeeks.com/centos/$releasever/RPM-GPG-KEY-CentOS-Official

[PowerTools]
name=CentOS-$releasever - PowerTools
baseurl=//repos.computingforgeeks.com/centos/$releasever/PowerTools/$basearch/os/
gpgcheck=1
enabled=0
gpgkey=//repos.computingforgeeks.com/centos/$releasever/RPM-GPG-KEY-CentOS-Official

[cr]
name=CentOS-$releasever - cr
baseurl=//repos.computingforgeeks.com/centos/$releasever/cr/$basearch/os/
gpgcheck=1
enabled=0
gpgkey=//repos.computingforgeeks.com/centos/$releasever/RPM-GPG-KEY-CentOS-Official

[fasttrack]
name=CentOS-$releasever - fasttrack
baseurl=//repos.computingforgeeks.com/centos/$releasever/fasttrack/$basearch/os/
gpgcheck=1
enabled=0
gpgkey=//repos.computingforgeeks.com/centos/$releasever/RPM-GPG-KEY-CentOS-Official
EOF

# Perform update
yum clean all
yum upgrade -y && yum update -y