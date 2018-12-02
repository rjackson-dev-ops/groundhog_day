#!/usr/bin/env ruby

require 'aws-sdk'

queue_match  = ARGV[0]

client = Aws::SQS::Client.new(
  region: 'us-east-1'
)

resp = client.list_queues({
})

queue_urls = resp.queue_urls

if queue_match.nil? || queue_match.empty?
  puts "Showing Policy Attribute for all queues in this account"
  matching_queue_urls = queue_urls
else
  puts "Showing Policy Attribute for queues matching #{queue_match}"
  queue_match = queue_match.to_s.downcase
  matching_queue_urls = queue_urls.select { |queue_url| /#{queue_match}/ =~ queue_url.to_s.downcase }
end

# matching_queue_urls.each do |queue_url|
#   puts "Queue URL: #{queue_url}"
# end

# list policies for each of these queues

matching_queue_urls.each do |queue_url|
  resp = client.get_queue_attributes({
    queue_url: queue_url, # required
    attribute_names: ["Policy"], # accepts All, Policy, VisibilityTimeout, MaximumMessageSize, MessageRetentionPeriod, ApproximateNumberOfMessages, ApproximateNumberOfMessagesNotVisible, CreatedTimestamp, LastModifiedTimestamp, QueueArn, ApproximateNumberOfMessagesDelayed, DelaySeconds, ReceiveMessageWaitTimeSeconds, RedrivePolicy, FifoQueue, ContentBasedDeduplication, KmsMasterKeyId, KmsDataKeyReusePeriodSeconds
  })
  puts "Queue: #{queue_url}"
  puts "Policy: #{resp.attributes["Policy"]}"
end

