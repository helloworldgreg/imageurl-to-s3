#!/bin/bash

# Getting the 3 characters of the file extension (e.g: jpg, png, ...)
fileUrl=$1
fileExtension=${fileUrl: -3}
echo "The file extension is: $fileExtension"

# Downloading the file as 'original.fileExtension'
curl $fileUrl --output "original.${fileExtension}"
echo "The downloaded file should now be in the directory: "
ls

# No matter what the file extension is, convert it to 'converted.targetExtension'
newExtension=$3
convert "original.${fileExtension}" "converted.${newExtension}"
echo "The file should now be available with the new extension: "
ls

# Uploading the converted file to S3
s3BucketName=$2
s3Destination="s3://${s3BucketName}"
echo "Destination used for the aws s3 cp command is: "
echo $s3Destination
aws s3 cp "converted.${newExtension}" $s3Destination # the AWS CLI will automatically use the metadata service for IAM role

echo "SCRIPT DONE"