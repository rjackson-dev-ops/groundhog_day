import sys, os, boto, boto.cloudformation

stack_id = sys.argv[1]
stack_name = "DFDDF-Stack-" + stack_id

cfnconn = boto.cloudformation.connect_to_region("us-east-1")

print "Deleting Stack: \n"
cfnconn.delete_stack(stack_name)