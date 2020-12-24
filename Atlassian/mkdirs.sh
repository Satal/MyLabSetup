mkdir -p /var/atlassian/bitbucket-data
mkdir -p /var/atlassian/confluence-data
mkdir -p /var/atlassian/jira-data
mkdir -p /var/atlassian/servicedesk-data
mkdir -p /var/postgres-data

chmod 777 /var/atlassian -R
chmod g+s /var/atlassian
chmod 777 /var/postgres-data -R
chmod g+s /var/postgres-data