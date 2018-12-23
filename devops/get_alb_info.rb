#!/usr/bin/env ruby

require 'aws-sdk'
require 'pp'

alb_arn  = ARGV[0]

client = Aws::ElasticLoadBalancingV2::Client.new(
  region: 'us-east-1'
)

iam_client = Aws::IAM::Client.new(
	region: 'us-east-1'
)

# Get ALB Name/Info
resp  = client.describe_load_balancers({
        load_balancer_arns: [
                alb_arn
				]
})

load_balancer = resp.load_balancers[0]

puts "Load Balancer Data"
puts "Load lablancer name:  #{load_balancer.load_balancer_name}"
puts "Load lablancer DNS:  #{load_balancer.dns_name}"

puts "Security Groups: #{load_balancer.security_groups}"

resp  = client.describe_listeners({
	load_balancer_arn: 
		alb_arn,
})

listeners = resp.listeners

listeners.each do |listener| 

		puts "Listener Data"
		puts "Listener ARN: #{listener.listener_arn}"

		certificates = listener.certificates
		certificates.each do |certificate|
			name = certificate.certificate_arn.rpartition('/').last

			puts "The certificate arn is " + name

		resp = iam_client.get_server_certificate({
			server_certificate_name: name, 
		})

			server_cert = resp.server_certificate
			puts "The server cert name is: " + server_cert.server_certificate_metadata.server_certificate_name
			puts "The server cert name expiration is: " + server_cert.server_certificate_metadata.expiration.to_s
			puts "The server cert name upload date is: " + server_cert.server_certificate_metadata.upload_date.to_s

		end

end
