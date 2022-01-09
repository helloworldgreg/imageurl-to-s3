# Image URL to S3
Dockerized bash script you can use to easily convert an image 
(given as a public URL) and save it into a S3 bucket.

You simply have to pass as docker arguments:
- the image URL
- the S3 bucket name where the converted image will be stored
- a new file extension ('jpg' / 'png' / ...) to use

## Usage
`docker run -it [SOURCE-IMAGE-URL] [S3-DESTINATION-BUCKET] [NEW-IMAGE-EXTENSION]`    
  
Example:  
`docker run -ti converter https://i.picsum.photos/id/822/536/354.jpg mybucket png`

## Details
This project is intended to be launched in an AWS environment (ECS, EC2, ...).  
Hence, the AWS CLI inside the container will automatically use the IAM role attached to
the instance (available in the metadata service) to upload the image to S3.

3 inputs need to be provided as command arguments:
- source URL of your image
- the S3 bucket name where the image will be stored
- the new file extension to use for the downloaded image

## Installation
### 1) build the image
`docker build -t converter .`

### 2) Test locally
`docker run -ti converter https://i.picsum.photos/id/822/536/354.jpg mybucket png`

You should get the following error
> upload failed: ./converted.png to s3://mybucket/converted.png Unable to locate credentials

That's simply because the AWS CLI in the docker cannot access any metadata to get its role credentials yet.  
If you try out in ECS and it will work because the AWS CLI will use the IAM task role configured in ECS.

#### Debug
There are some echo commands in the script so you can
easily debug the execution by taking a look at the ClouWatch logs
when the script is executing in AWS or locally

#### Tips
- For s3 bucket name use 'mybucket' or 'mybucket/path/path/' if a path is needed