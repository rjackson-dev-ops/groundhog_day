# This makefile is used to update a pipeline and all the resources  with it. This includes
# the CodePipeline and the associated CodeBuild jobs.
#
#


consumer_profile := sandbox
consumer_region := us-west-2
consumer_zone := us-west-2a
consumer_environment := sbx-vpl-poc
consumer_tags := 'Key=ApplicationName,Value=clougeng-workload Key=ApplicationID,Value=169 Key=Environment,Value=$(consumer_environment) Key=ProductOwnerEmail,Value=awalker@mmm.com Key=AlternateEmail,Value=gzachariah.cw@mmm.com'


pl_profile := gtd
pl_region := us-west-2
pl_zone := us-west-2a
pl_environment := gtd-vpl-poc

pl_tags := 'Key=ApplicationName,Value=clougeng-workload Key=ApplicationID,Value=169 Key=Environment,Value=$(pl_environment) Key=ProductOwnerEmail,Value=awalker@mmm.com Key=AlternateEmail,Value=gzachariah.cw@mmm.com'

# help:
# 	@echo "Targets:"
# 	@echo "    get-pipeline  -- Download the pipline CFN template for into CodePipeline/pipeline.yml"
# 	@echo "    put-pipeline  -- Update the pipeline with CodePipeline/pipeline.yml"

.PHONY: list
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

describe-keypairs:
	echo "Service VPC ec2 keys\n";\
	aws ec2 describe-key-pairs \
    	--profile $(pl_profile) --region $(pl_region) \
		--query "KeyPairs[*].{KeyName:KeyName}" \
		--output text;\
	echo "Consumer VPC ec2 keys\n";\
	aws ec2 describe-key-pairs \
    	--profile $(consumer_profile) --region $(consumer_region) \
		--query "KeyPairs[*].{KeyName:KeyName}" \
		--output text;

# make key_file_path=~/.ssh/key.pub key_name=my_key import-keypair
import-keypair:
	-aws ec2 import-key-pair \
   		--profile $(consumer_profile) --region $(consumer_region) \
    	--key-name $(key_name) --public-key-material fileb://$(key_file_path);\
	aws ec2 import-key-pair \
   		--profile $(pl_profile) --region $(pl_region) \
    	--key-name $(key_name) --public-key-material fileb://$(key_file_path);

create-instance-profile-stacks:
	-scripts/create-stack.sh -p $(pl_profile) -r $(pl_region) -n $(pl_environment)-ec2-profile \
		-b file://Cloudformation/instance-role.yml \
		-t $(pl_tags);\
	scripts/create-stack.sh -p $(consumer_profile) -r $(consumer_region) -n $(consumer_environment)-ec2-profile \
		-b file://Cloudformation/instance-role.yml \
		-t $(consumer_tags);

delete-instance-profile-stacks:
	-scripts/delete-stack-by-name.sh -p $(pl_profile) -r $(pl_region) \
	 -n $(pl_environment)-ec2-profile;\
	scripts/delete-stack-by-name.sh -p $(consumer_profile) -r $(consumer_region) \
	 -n $(consumer_environment)-ec2-profile;

create-privatelink-stacks:
	-scripts/create-stack.sh -p $(pl_profile) -r $(pl_region) -n $(pl_environment)-vpc \
		-b file://Cloudformation/vpc-endpoint-privatelink-service.yml \
		-m  file://Cloudformation/parameters/service-parameters.json \
		-t $(pl_tags);\
	scripts/create-stack.sh -p $(consumer_profile) -r $(consumer_region) -n $(consumer_environment)-vpc \
		-b file://Cloudformation/vpc-endpoint-private-link-consumer.yml \
		-m  file://Cloudformation/parameters/consumer-parameters.json \
		-t $(consumer_tags);

delete-privatelink-stacks:
	-scripts/delete-stack-by-name.sh -p $(pl_profile) -r $(pl_region) \
	 -n $(pl_environment)-vpc;\
	scripts/delete-stack-by-name.sh -p $(consumer_profile) -r $(consumer_region) \
	 -n $(consumer_environment)-vpc;


# get-region-azs:
# 	aws ec2 describe-availability-zones \
# 		--profile $(profile) --region $(region) \
# 		--filters "Name=region-name,Values=us-west-2" \
# 		--query "AvailabilityZones[*].{State:State,ZoneName:ZoneName,ZoneType:ZoneType}"


# get-region-tgws:
# 	aws ec2 describe-transit-gateways \
# 		--profile $(regional_networking_profile) --region $(region) \
# 		--query "TransitGateways[*].{TransitGatewayId:TransitGatewayId,\
# 			TransitGatewayArn:TransitGatewayArn,Description:Description,\
# 			CreationTime:CreationTime,State:State}"


# get-regional-network-private-hosted-zone:
# 	aws route53 get-hosted-zone \
# 		--profile $(regional_networking_profile) \
# 		--id $$regional_hosted_zone_id	

# list-regional-network-private-hosted-zones:
# 	aws route53 list-hosted-zones \
# 		--profile $(regional_networking_profile)


# authorize-workload-vpc-for-network-zone:
# 	aws route53 --profile $(regional_networking_profile) \
# 		create-vpc-association-authorization --hosted-zone-id $$regional_hosted_zone_id \
# 		--vpc VPCRegion=$(region),VPCId=$$workload_vpc

# associate-zone-with-workload-vpc:
# 	aws route53 --profile $(profile) \
# 		associate-vpc-with-hosted-zone \
# 		--hosted-zone-id $$hosted_zone_id \
# 		--vpc VPCRegion=$(region),VPCId=$$workload_vpc

# delete-zone-authorization:
# 	aws route53 --profile $(regional_networking_profile) \
# 		delete-vpc-association-authorization \
# 		--hosted-zone-id $$regional_hosted_zone_id \
#     	--vpc VPCRegion=$(region),VPCId=$$workload_vpc 



# get-regional-network-resolver-rules:
# 	echo "Resolver Rules from Regional Account\n";\
# 	aws route53resolver list-resolver-rules \
# 	 	--filters "Name=Name,Values=NetworkingHostedZone,MMM,CorpLocal" \
# 		--profile $(regional_networking_profile) --region $(region) \
# 		--query "ResolverRules[*].{Id:Id,Arn:Arn,DomainName:DomainName,Status:Status,Name:Name}";\
# 	echo "\n\nList for python script\n";\
# 	aws route53resolver list-resolver-rules \
# 	 	--filters "Name=Name,Values=NetworkingHostedZone,MMM,CorpLocal" \
# 		--profile $(regional_networking_profile) --region $(region) \
# 		--query "ResolverRules[*].{id:Id,name:Name}" | tr -d '[:space:]';\
# 	echo "\n\n";
		

# get-regional-network-tgw:
# 	 aws ec2 describe-transit-gateways \
# 		--profile $(regional_networking_profile) --region $(region) \
# 		--query "TransitGateways[*].{AmazonSideAsn:AmazonSideAsn,CreationTime:CreationTime, \
# 			Description:Description,OwnerId:OwnerId,State:State,TransitGatewayArn:TransitGatewayArn, \
# 			TransitGatewayId:TransitGatewayId}"

# get-cidr-topic:
# 	 aws sns list-topics \
# 		--profile $(gt_profile) --region $(region) \
# 		--query "Topics[?contains(TopicArn,'cidr-registration-topic')]"

# create-workload-stack:
# 	scripts/create-stack.sh -p $(profile) -r $(region) -n $(environment)-vpc \
# 		-b file://$${workload_template} \
# 		-t $(tags)

# delete-workload-stack:
# 	scripts/delete-stack-by-name.sh -p $(profile) -r $(region) \
# 	 -n $(environment)-vpc

# get-island-subnet:
# 	aws ec2 describe-subnets \
# 		--profile $(profile) --region $(region) \
# 		--query "Subnets[?Tags[?Value == 'IslandSubnet1']].{SubnetId:SubnetId,VpcId:VpcId,Tags:Tags}"

# get_proxy_url:
# 	aws ssm get-parameter --name "/account/networking/proxyurl" \
# 		--profile $(regional_networking_profile) --region $(region)	

# create-test-parameters:
# 	scripts/create_proxy_test_data.py -a $(profile) -r $(region) \
#                 -l $(zone) \
#                 -f $$parameter_file \
#                 -p $(environment) \
#                 -w github.com \
#                 -u $$proxy_url \
#                 -o  3128

# create-workload-test-stack:
# 	scripts/create-stack.sh -p $(profile) -r $(region) -n $(environment)-test-stack \
# 		-b file://CloudFormation/workload-proxy-test-template.yaml \
# 		-m file://$${parameter_file} \
# 		-t $(tags)

# delete-workload-test-stack:
# 	scripts/delete-stack-by-name.sh -p $(profile) -r $(region) \
# 	 -n $(environment)-test-stack
		