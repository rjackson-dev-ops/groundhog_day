#!/usr/bin/env ruby

require 'aws-sdk'

rds = Aws::RDS::Resource.new(
  region: 'us-east-1'
)

puts "Enter the Snapshot search string"
search_string = gets.chomp

rds.db_snapshots.each do |s|
  if s.snapshot_id.include? "#{search_string}"
    puts "Name (ID): #{s.snapshot_id}"
    puts "Status:    #{s.status}"
    puts "Deleting  #{s.snapshot_id}"
    sleep 5
    # Don't uncomment these lines unitl you are sure you have
    # the right search string
    # resp = rds.client.delete_db_snapshot({
    #   db_snapshot_identifier: "#{s.snapshot_id}",
    # })
  end
end
