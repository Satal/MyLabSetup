readonly DOMAIN=mylab.local
readonly DOMAIN_USER=administrator

# Ensure we are running as root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root, please try again as root"
    exit
fi

# Install dependencies
dnf install realmd sssd oddjob oddjob-mkhomedir adcli samba-common samba-common-tools krb5-workstation authselect-compat -y

# Join the domain
realm join $DOMAIN -U $DOMAIN_USER
authselect select sssd
authselect select sssd with-mkhomedir
systemctl restart sssd

# Deny all realm users from logging in this allows us to then whitelist the user
realm deny --all
realm permit --groups domain\ admins # Allow domain Admins (I suppose we should)
# realm permit -g usergroup@domain


# Specify that the user is a sudoer
echo "${DOMAIN_USER}@${DOMAIN}        ALL=(ALL)       ALL" >> /etc/sudoers.d/domain_admins