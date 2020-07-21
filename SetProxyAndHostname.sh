if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root, please try again as root"
    exit
fi

echo 'proxy=http://10.0.1.51:8080' >> /etc/dnf/dnf.conf

read -p 'Please specify the new hostname' newhostname
hostname $newhostname