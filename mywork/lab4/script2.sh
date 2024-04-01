import boto3 

s3 = boto3.client('s3', region_name='us-east-1') 

bucket_name = 'ds2002-ap6acf 

local_file_path = ‘Downloads/2002' 

s3_file_key = 'tundy.png’ 

with open(local_file_path, 'rb') as file: 
	s3.upload_fileobj(file, bucket_name, s3_file_key) 

presigned_url = s3.generate_presigned_url( 
	`get_object', 
	Params={'Bucket': bucket_name, 'Key': s3_file_key}, 
	ExpiresIn=604800 
)
 
print("Presigned URL:", presigned_url)
