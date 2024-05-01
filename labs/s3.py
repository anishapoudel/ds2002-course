import requests
import boto3

remote_file = 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'

# 1. Fetch remote file
r = requests.get(remote_file, allow_redirects=True)
open("google.png", "wb").write(r.content)

# 2. Upload file to bucket

bucket = 'ds2002-resources'
local_file = 'google.png'
remote_key = 'google.png'

s3 = boto3.client('s3')

response = s3.put_object(
    Body = local_file,
    Bucket = bucket,
    Key = remote_key
)

# 3. Presign

bucket_name = "ds2002-resources"
object_name = "google.png"
expires_in = 604800

response = s3.generate_presigned_url(
    'get_object',
    Params={'Bucket': bucket_name, 'Key': object_name},
    ExpiresIn=expires_in
    )

print(response)
