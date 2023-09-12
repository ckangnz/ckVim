# AWS Tools

- CloudWatch
  - Logs
- S3
  - File storage
- Lambda
  - Methods
- EC2
  - Deployed resources
- RDS
  - DB Instances
- Cloud9
  - Virtual IDE
- VPC
  - Virtual Private Cloud

# Configuring profile

```bash
# Set default credential
aws configure

# OR set profile credential
aws configure set profile.<MY-PROFILE-ALIAS>.aws_access_key_id <ACCESS-KEY-ID>
aws configure set profile.<MY-PROFILE-ALIAS>.aws_secret_access_key <SECRET-ACCESS-KEY>
aws configure set profile.<MY-PROFILE-ALIAS>.region <YOUR-REGION>
aws configure set profile.<MY-PROFILE-ALIAS>.role_name <ROLE-NAME>

#You could use sso
aws configure sso
# SSO session name : NAME YOUR SESSION
# SSO start URL : https://*.awsapps.com/start#

#Login with sso
aws sso login --sso-session <NAME OF YOUR SESSION>

# Get your current AccountId / Arn / UserId
aws sts get-caller-identity

# Get list of your profiles
aws configure list-profiles
```

# IAM Policies

```bash
# Get Policy Arn
aws iam list-policies --profile <MY-PROFILE-ALIAS>

# Attach Policy Arn
aws iam attach-role-policy --policy-arn $POLICYARN --role-name $ROLE --profile <MY-PROFILE-ALIAS>

# Get Policy Version
aws iam get-policy-version --policy-arn $POLICYARN --profile <MY-PROFILE-ALIAS>
```

# S3 bucket

```bash
# Make Bucket
aws s3 mb s3://<BUCKET-NAME> --profile <MY-PROFILE-ALIAS>

# Remove Bucket
aws s3 rb s3://<BUCKET-NAME> --profile <MY-PROFILE-ALIAS>

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
