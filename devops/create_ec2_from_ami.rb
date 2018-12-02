require 'aws-sdk'

region = 'us-east-1'

puts "Enter the AMI ID you want to launch with:"
ami_id = gets.chomp
puts "Enter the name of the instance you are creating:"
instance_name = gets.chomp
puts "Enter the keypair name for your instance:"
key_pair = gets.chomp
puts "Enter the environment - must be either 'prod' or 'nonprod':"
environment = gets.chomp

if environment == 'nonprod'
  sg_id = "sg-afdafsdfsaf"
  subnet_id = "subnet-afdafsdfsaf"
elsif environment == 'prod'
  sg_id = "sg-afdafsdfsaf"
  subnet_id = "subnet-afdafsdfsaf"
end


ec2 = Aws::EC2::Client.new(
  region: region
)

resp = ec2.run_instances({
  image_id: ami_id,
  instance_type: "m4.large",
  key_name: key_pair,
  max_count: 1,
  min_count: 1,
  security_group_ids: [
    sg_id,
  ],
  subnet_id: subnet_id,
  tag_specifications: [
    {
      resource_type: "instance",
      tags: [
        {
          key: "Name",
          value: instance_name,
        },
        {
          key: "ECS:ServerFunction",
          value: "Docker",
        },
      ],
    },
  ],
})

puts "Waiting for instance to initiate..."
sleep 20
instance_id = resp.instances[0].instance_id
private_ip = resp.instances[0].private_ip_address
puts "Your instance ID is: #{instance_id}"
puts ""
puts "Use the following line to connect to your instance"
puts "================================================================="
puts "ssh -i #{key_pair}.pem ubuntu@#{private_ip}"
puts "================================================================="