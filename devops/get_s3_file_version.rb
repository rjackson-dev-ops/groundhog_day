require 'aws-sdk'
kms = Aws::KMS::Client.new region: 'us-east-1'
s3 = Aws::S3::Encryption::Client.new(
  kms_key_id: ENV['inventory_store_key'],
  kms_client: kms
)

content = s3.get_object(bucket: 'vis-prod-configs',
  key: 'svs-rails-app.yml',
  version_id: '6umpvGa8k.jVoytICvksbj8mbbfVX3J_').body.read
File.open('old_config.yml', 'wb') { |f| f.write(content) }