readonly DOMAIN=mylab.local
readonly DOMAIN_USER=administrator

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root, please try again as root"
    exit
fi

dnf install realmd sssd oddjob oddjob-mkhomedir adcli samba-common samba-common-tools krb5-workstation authselect-compat -y
#read -s -p 'Please provide the password for $DOMAIN_USER@$DOMAIN:'
realm join $DOMAIN -U $DOMAIN_USER
authselect select sssd
authselect select sssd with-mkhomedir
systemctl restart sssd
echo "${DOMAIN_USER}@${DOMAIN}        ALL=(ALL)       ALL" >> /etc/sudoers.d/domain_admins