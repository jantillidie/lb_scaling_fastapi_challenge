import boto3
from zipfile import ZipFile
import os
from os.path import basename

source_dir = "fastapi"

# create a ZipFile object
with ZipFile('fastapi.zip', 'w') as zipObj:
    # Iterate over all the files in directory
    for folderName, subfolders, filenames in os.walk(source_dir):
        for filename in filenames:
            # create complete filepath of file in directory
            filePath = os.path.join(folderName, filename)
            # Add file to zip
            zipObj.write(filePath, basename(filePath))

# create an S3 bucket
region = "us-west-2"
s3_client = boto3.client('s3', region_name=region)
location = {'LocationConstraint': region}
s3_client.create_bucket(Bucket="jansfastapibucket87293847", CreateBucketConfiguration=location)


# # upload the zip file
filename = 'fastapi.zip'
bucket_name = 'jansfastapibucket87293847'
s3_client.upload_file(filename, bucket_name, filename,
                      ExtraArgs={'ACL': 'public-read'})
