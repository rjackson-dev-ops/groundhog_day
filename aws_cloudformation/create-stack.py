
import sys, os, boto, boto.cloudformation, time, uuid

if sys.argv[1] == "auto-generate":
    stack_id = uuid.uuid1().hex
else:
    stack_id = sys.argv[1]

owner_contact = sys.argv[2]
vpc = sys.argv[3]

stack_name = "TEST-Stack-" + stack_id

if vpc == "Dev":
    subnets = "subnet-fa35038d,subnet-ff6f26a6,subnet-fc35038b"
    AppELBSubnets = "subnet-fc35038b,subnet-ff6f26a6"
    security = "sg-0932896e"
    environment = "ENVNPTEST"
    centrify = "DAWS_ENVNP_TEST_CG"
    domain = "dqa.your_company.com"
    chefserver = "aws-east"
    cheforg = "dev"
    keyname = "adaf_TEST_Test"
    zabbixrecipe = "recipe[emmo_zabbixagent::adaf-e-dev]"
elif vpc == "QA":
    subnets = "subnet-6a7f781d,subnet-d46f318d,subnet-fdc88ad6"
    AppELBSubnets = "subnet-6a7f781d,subnet-d46f318d,subnet-fdc88ad6"
    security = "sg-12e9f975,sg-5d667c3a,sg-50f71237,sg-b33f97d5,sg-d0e71da9"
    environment = "ENVNPTEST"
    centrify = "QAWS_ENVNP_TEST_CG"
    domain = "dqa.your_company.com"
    chefserver = "aws-east"
    cheforg = "preprod"
    keyname = "adaf_TEST_Test"
    zabbixrecipe = "recipe[emmo_zabbixagent::adaf-e-dev]"
elif vpc == "Prod":
    subnets = "subnet-30372b47,subnet-1d1d2b44,subnet-329db919"
    AppELBSubnets = "subnet-30372b47,subnet-1d1d2b44,subnet-329db919"
    security = "sg-4d3f982a,sg-2fc8ec56,sg-78c8ec01,sg-493a2e2e"
    environment = "ENVPRTEST"
    centrify = "PAWS_ENVPR_CLO_CG"
    domain = "cof.ds.your_company.com"
    chefserver = "aws-east"
    cheforg = "prod"
    keyname = "Picasso"
    zabbixrecipe = "recipe[emmo_zabbixagent::fs-e-prod]"

cfnconn = boto.cloudformation.connect_to_region("us-east-1")
print "\nCreating stack...\n"

cfnoutput = cfnconn.create_stack(
	stack_name,
	template_url = "https://s3.amazonaws.com/adaf-nonprod-dfdsaf/cloud-formation-templates/dfdsaf_stack.json",
parameters = [ ("UUID", stack_id), ("OwnerContact", owner_contact), ("SecurityGroupIds", security), ("Subnets", subnets), ("AppELBSubnets", AppELBSubnets), ("CMDBEnvironment", environment), ("CentrifyEnv", centrify), ("Domain", domain), ("ChefServer", chefserver), ("ChefOrg", cheforg), ("KeyName", keyname),("ZabbixRecipe", zabbixrecipe) ]
)

if "arn:aws:cloudformation:" not in cfnoutput:
    print "Stack create failed."
    sys.exit(2)
else:
    # Wait for Stack to finish
    stacks = cfnconn.describe_stacks(stack_name)
    stack = stacks[0]
    lcv = 0
    print "\nWaiting for stack to complete..."
    while "CREATE_COMPLETE" not in stack.stack_status:
        lcv += 1
        if "ROLLBACK" in stack.stack_status:
            print "\nStack is being rolled back. Check the cloudformation events for your stack to troubleshoot: " + stack_name
            sys.exit(2)
        if lcv > 60:
            print "\nStack did not complete."
            print "Sending cfn delete: \n"
            cfnconn.delete_stack(stack_name)
            sys.exit(2)
        time.sleep(10)
        stacks = cfnconn.describe_stacks(stack_name)
        stack = stacks[0]

    stacks = cfnconn.describe_stacks(stack_name)
    stack = stacks[0]
    for output in stack.outputs:
        if output.key == "elbURL":
            elb_url = output.value

    print "\nStack complete"
    print "Stack Name = " + stack_name
    print "Stack ID = " + stack_id
    print "Stack ELB URL= " + elb_url