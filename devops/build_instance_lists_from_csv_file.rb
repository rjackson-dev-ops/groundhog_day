#!/usr/bin/env ruby

require 'aws-sdk'
require 'pp'
require "csv"
require 'yaml'
require 'ipaddr'

# This script uses a cidr yaml file and a csv file with instances to generate
# two text files with instances separated by nonprod vs. prod accounts

# The format of the CIDR yaml property file should be like this:

# Production:
# - subnet: subnet-idfaaff
#   cidr: 10.22.22.0/25
# - subnet: subnet-idfaaff
#   cidr: 10.22.22.0/25
# - subnet: subnet-idfaaff
#   cidr: 10.22.22.0/25

# Nonprod:
# - subnet: subnet-idfaaff
#   cidr: 10.22.22.0/25
# - subnet: subnet-idfaaff
#   cidr: 10.22.22.0/25
# - subnet: subnet-idfaaff
#   cidr: 10.22.22.0/25
# - subnet: subnet-34344324
# 	cidr: 10.22.22.0/24

# The csv file should have thei ip addresses in a column called "private_ip"


def check_ip_in_account (account_cidr_struct, ip)
	ip_addr = IPAddr.new(ip)
	account_cidr_struct.each do |key, range_array|
		range_array.each do |cidr_range|

			if cidr_range.include?(ip_addr)
				return key
			end
		end
	end

	# Return empty string if we don't find a match
	return ''
end

region = 'us-east-1'
data_dir = 'datadir'

puts "Enter the cidr property file name"
cidr_property_file = gets.chomp

if cidr_property_file.to_s.empty?
	puts "Please run the command again and enter a valid cidr property file"
	exit
end

cidr_file_path = data_dir + cidr_property_file
puts "The CIDR property file is: " + cidr_file_path

puts "Enter the input csv file"
file_name = gets.chomp

if file_name.to_s.empty?
	puts "Please run the command again and enter a valid csv file"
	exit
end

csv_file_path = data_dir + file_name
puts "The the csv file is: " + csv_file_path

cidr_data = YAML.load_file(cidr_file_path)

account_cidr_struct = Hash.new

cidr_data.each do |key, array|

	cidr_array = Array.new

	# build cidr struct
	array.each do |subnet_cidr|
		 next_cidr = IPAddr.new subnet_cidr['cidr']
		 cidr_array.push next_cidr
	end

	account_cidr_struct[key] = cidr_array

end

# Process incoming csv

csv = CSV.read(csv_file_path, :headers=>true)

instance_list =  csv['private_ip']

production_list = Array.new

file_name_only = File.basename(file_name,File.extname(file_name))

production_instance_file = data_dir + file_name_only + '_production.txt'

nonprod_list = Array.new
nonprod_instance_file = data_dir + file_name_only + '_nonprod.txt'

instance_list.each do |instance_ip|
	account = check_ip_in_account(account_cidr_struct, instance_ip)

	if account == 'Production'
		production_list.push instance_ip
	elsif account == 'Nonprod'
		nonprod_list.push instance_ip
	else
		puts "This ip is not in prod or nonprod: " + instance_ip
	end

	File.open(production_instance_file, "w+") do |f|
		f.puts(production_list)
	end

	File.open(nonprod_instance_file, "w+") do |f|
		f.puts(nonprod_list)
	end
end

# client = Aws::ElasticLoadBalancingV2::Client.new(
#   region: 'us-east-1'