require 'aws-sdk'
kms = Aws::KMS::Client.new region: 'us-east-1'
s3 = Aws::S3::Encryption::Client.new(
  kms_key_id: ENV['inventory_store_key'],
  kms_client: kms
)

content = s3.get_object(bucket: 'prod-configs',
  key: 'confile_file.yml',
  version_id: '6umpvGa8k.3q3q483043084').body.read
File.open('old_config.yml', 'wb') { |f| f.write(content) }