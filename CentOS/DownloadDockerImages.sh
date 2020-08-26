#!/bin/bash
declare -a docker_images("atlassian/jira-servicedesk" "atlassian/bitbucket-server")

for i in "${docker_images[@]}"
docker_images
	docker pull $i && docker save --output ${i//\//-}_docker.tar $i
done