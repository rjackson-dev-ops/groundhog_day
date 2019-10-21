#!/usr/bin/env ruby

require 'aws-sdk-rds'
require 'aws-sdk-cloudformation'
require 'crossing'
require 'trollop'

# I pulled the stacks using get_stack_by_name.sh jasper | grep -i rds

opts = Trollop::options do
  opt :account, "prod or nonprod", :type => :string, :default => "nonprod"
  opt :filter, "filter for stacks", :type => :string, :default => nil
end

account = opts[:account]
filter = opts[:filter]

puts "The account chosen is #{account}"

if account=='prod'
  bucket = 'vis-prod-configs'
else
  bucket = 'vis-nonprod-configs'
end

app_rds_stack_file='app_rds_stacks.txt'

kms = Aws::KMS::Client.new region: ENV['region']
  s3 = Aws::S3::Encryption::Client.new(
    kms_key_id: ENV['inventory_store_key'],
    kms_client: kms,
    region: ENV['region']
  )

crossing = Crossing.new(s3)
app_rds_stacks = crossing.get_content(bucket, app_rds_stack_file)

cloudformation = Aws::CloudFormation::Client.new(
  region: ENV['region']
)

rds = Aws::RDS::Client.new(
  region: ENV['region']
)

app_rds_stacks.each_line do |next_line|
  stack_name = next_line.delete!("\n")

  if filter
    #puts "Filter is: #{filter}"
    next if stack_name.downcase !~ /#{filter.downcase}/
  end

  puts "RDS Stack: #{stack_name}"

  response = cloudformation.describe_stack_resources ({
    stack_name: stack_name
  })

  stack_resources = response.stack_resources

  stack_resources.each do |next_resource|
    if next_resource.resource_type.include? "DBInstance"
      identifier = next_resource.physical_resource_id

      puts "physical_resource_id: #{identifier}"

      response = rds.describe_db_instances({
        db_instance_identifier: identifier
      })

      deletion_protection = response.db_instances[0].deletion_protection

      puts "RDS Endpoint:  #{response.db_instances[0].endpoint.address}"
      puts "RDS StorageType:  #{response.db_instances[0].storage_type}"


      puts "Deletion Protection: #{deletion_protection}"
      if deletion_protection == false
          puts "This instance needs protecting"
          response = rds.modify_db_instance({
            db_instance_identifier: identifier,
            deletion_protection: true
          })

          puts "The updated deletion protection is: "
          puts response.db_instance.deletion_protection
      end
    end
  end
end

