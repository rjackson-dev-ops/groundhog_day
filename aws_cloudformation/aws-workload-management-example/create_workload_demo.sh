aws cloudformation create-stack --stack-name RjacksonWorkloadDemo \
   --template-body file:////Users/rjackson/projects/groundhog_day/aws_cloudformation/aws-workload-management-example/workload-yaml-master.yml \
  --parameters  file:///Users/rjackson/projects/groundhog_day/aws_cloudformation/aws-workload-management-example/workload_parameters.json 