docker_repo=`keystore.rb retrieve --table=$key_table --keyname="APP_PRIVATE_DOCKER_REGISTRY_URL_NEXUS"`
nexus_user=`keystore.rb retrieve --table=$key_table --keyname="NEXUS_USERNAME"`
nexus_password=`keystore.rb retrieve --table=$key_table --keyname="NEXUS_PASSWORD"`
set -x
docker login -u $nexus_user -p $nexus_password $docker_repo

