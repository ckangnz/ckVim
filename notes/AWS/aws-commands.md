# AWS Tools

#### CloudWatch
- Logs
#### S3
- File storage
#### Lambda
- Methods
#### EC2
- Deployed resources
#### RDS
- DB Instances
#### Cloud9
- Virtual IDE
#### VPC
- Virtual Private Cloud

# Configuring profile

```bash
aws configure
# Type in AWS Access Key ID: ....

aws configure set profile.<MY-PROFILE-ALIAS>.aws_access_key_id <ACCESS-KEY-ID>
aws configure set profile.<MY-PROFILE-ALIAS>.aws_secret_access_key <SECRET-ACCESS-KEY>
aws configure set profile.<MY-PROFILE-ALIAS>.region <YOUR-REGION>
aws configure set profile.<MY-PROFILE-ALIAS>.role_name <ROLE-NAME>
```

# S3 bucket

```bash
# MakeBucket
aws s3 mb s3://<BUCKET-NAME> --profile <MY-PROFILE-ALIAS>
# make_bucket : <BUCKET-NAME>

# Upload
aws s3 cp ./file_name s3://<BUCKET-NAME> --profile <MY-PROFILE-ALIAS>

# Find S3 Bucket name
aws s3 ls | grep MyBucketName
# returns MyBucketName-xxx-xxxxxx
```

# Lambda

```bash
# Giving lambda function a permission to trigger on S3 bucket
aws lambda add-permisison
    --function-name <LAMBDA-FUNCTION-NAME>
    --statement-id e.g.PolicyDocument
    --action "lambda:InvokeFunction"
    --principal s3.amazonaws.com
    --source-arn arm:aws:s3:::<BUCKET-NAME>
    --source-account <AWS-ACCOUNT-ID>
    --profile <MY-PROFILE-ALIAS>
```


# Elastic Beanstalk
- Deploy an app to EB environment
##### You need AWS EB CLI

```bash
# Initialize
eb init --profile <MY-PROFILE-ALIAS>
# Select a default region

# Deploy
eb deploy --profile <MY-PROFILE-ALIAS>

```

# CloudFormation
- Specify/Deploy/Configure serverless application (API)

```bash
# Uses AWS SAM template and rewrites it in terms of the artifacts automatically uploaded to the specified S3 bucket
# This template represents your Serverless application
# It will create Lambda/S3 buckets/CloudWatch logs etc. automatically

# Using `template.yaml` SAM template
aws cloudformation package
    --template-file template.yaml
    --s3-bucket <BUCKET-NAME>
    --output-template <OUTPUT-TEMPLATE>.yaml
    --profile <MY-PROFILE-ALIAS>

# Deploy artifact as a Lambda function
aws cloudformation
    --template-file <OUTPUT-TEMPLATE>.yaml
    --stack-name <STACK-NAME>
    --profile <MY-PROFILE-ALIAS>
```

# Cloud Development Kit (CDK)

```bash
# Install cdk cli
npm i -g aws-cdk

# Initialize Typescript project
cdk init -l typescript

# First time deploying AWS CDK for a specific AWS account and AWS Region
# Bootstrap an environment is must
cdk bootstrap

# List the CloudFormation template
cdk synth

# Deploy CDK
cdk deploy

# Delete all resources related to the cdk
cdk destroy
```
