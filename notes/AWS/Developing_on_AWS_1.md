# Day 1

![](/notes/AWS/Developing_on_AWS.png)

## Module1: Building a Web Application on AWS

### Building a Cloud-Native application

- This application uses serverless applications such as Amazon API Gateway/ Lambda/ DynamoDB
- You won't be replying on the AWS Management Console

### Amazon Polly

- Generates natural-sounding human speech

### Identity and Access Management (IAM) permissions

- Interact with AWS resources using IDE with AWS SDKs and toolkits
- Use IAM to manage access to AWS resources securely
- By configuring Integrated Development Environment (IDE), you can:
  - securely manage access to AWS resources
  - call AWS services through the AWS SDK and toolkits
  - build applications without using the AWS Management Console interface

### Amazon S3

- Front-end hosting (Main website user interface)
- User file storage
- The Pollynotes application uses AWS S3 buckets to host the website which acts as the application's frontend, and to store the MP3 files produced by Amazon Polly

### Dynamo DB

- Fully managed NOSQL database service
- Serverless / Capacity scaling

### AWS Lambda

- Serverless / Capaciy scaling
- powers the application's CRUD operations
- offer a workload-aware scaling solution that can be configured and maintained in your dev environment.

### Amazon API Gateway

- Directs event-driven requests
- logs calls to APIs
- User makes request -> REST API ->
  - API Gateway routes ther equest to the AWS resource -> APIGateway sends a response back to the user ->
    - -> User

### Amazon Cognito

- User pools
- user directories that create built-in sign-up and sign-in options for your app users.
- Identity pools
  - grant user access to other AWS services
    -These two can be used separately or together

### Amazon CloudWatch

- Observability
- Dashboards / Logs / Metrics / Alarms / Events

### AWS X-Ray

- Tracing
- Analyze your application
- Service maps

## Module2: Getting Started with Development on AWS

- Accessing AWS services programmatically
- List programmatic patterns within AWS SDKs
- Explain the value of AWS Cloud9

### AWS REST API

- AWS REST API is used to access AWS services programmatically without using AWS Console (UI)
- AWS REST API can:
  - run instances
  - upload files to Amazon S3 / create a bucket
  - update an item in a database
- For security, the user must be signed with an access key(ID /secret access key)
- The user sends Request to AWS REST API with
  - HTTP(S) request
  - Signature Version 4 (SigV4)
  - IAM access key (ID, secret)
- When a service responds to a request, the response header contains a status and the message
  - `1xx`: Informational
  - `2xx`: Success
  - `3xx`: Redirectional
  - `4xx`: Client Error
  - `5xx`: Server Error
- [AWS Management Console(UI)] / [AWS CLI] / [AWS SDKs] ==> [AWS REST API] ==> other services

| Client                      |     | API          |     | AWS Services   |
| --------------------------- | --- | ------------ | --- | -------------- |
| AWS Management Console (UI) |     |              |     |                |
| AWS CLI                     | ->  | AWS REST API | ->  | Other Services |
| AWS SDKs                    |     |              |     |                |

#### AWS Command line interface (AWS CLI)

- use to manage your AWS services directly from the command program
- uses Python SDK
- useful to automate to perform duplicated tasks

Example:

```bash
aws s3 ls s3://mybucket --recursive #List buckets
aws s3 mb s3://mybucket # Make bucket
aws s3 cp myFile.txt s3://mybucket # Copy file
aws dynamodb create-table --tablename …  # Create dynamo table
aws help
aws s3 help
```

#### AWS SDKs

- You need to perform the following operations to use AWS APIs:
  - Grant access to your application
  - Adjust the throttling to accounts for limited bandwidth
  - Integrate several services
- AWS SDKs cover and simplify some of these patterns
- SDKs are available in a number of programming languages and tech platforms (.NET, Node.js, PHP, Python etc.)

> Why use AWS SDKs?
>
> - Language binding
>   - can use your preferred language
> - HTTP request signing
>   - calculate signatures
> - Built-in resilience
>   - Logic for retries/errors/timeouts
> - Pagination support
>   - single line of code to use paginator

##### Low-level API (Service client API) vs. High-level API (Resource API)

- Low-level
  - has one method per service operation
- High-level
  - has one class per conceptual resource
  - defines service resources and individual resources

### IDE Toolkits

- AWS IDE toolkits are available for multiple IDEs
- Make it easier to create/debug/deploy apps using AWS

#### AWS Cloud9(Cloud-based IDE for AWS)

- Start projects quickly / code with only a browser
- code together in real time
- build serverless apps with ease
- can be built on EC2 instance

### Amazon CodeWhisperer

- AI coding companion
- Generates code suggestions based on comments and existing code
- rea-time support for code authoring directly within your IDE

## Module 4: Getting Started with Permissions

- Configure a development environment with the support of AWS identity and Access Management (IAM) permissions

### AWS Identity and Access Management (IAM)

- control access to AWS resources
- access to multiple AWS accounts
- IAM has these required fields
  - Action
  - Effect
  - Resource
- Authentication
  - who/what can be accessed
- Authorization
  - what they can do

#### Users

- team members/entity that represents the person/application to interact with AWS.

#### Groups

- A collection of IAM users
- specifies permissions for multiple users

#### Policies

- Define permissions for an action regardless of the method
- can attach an IAM customer managed policy
- by default all requests are denied
  - An explicit allow overrides this default
  - An explicit deny overrides any allows

#### Roles

- Truested entities that determine what the identity can and cannot do in AWS.

| Users | User groups | Policies and permissions | Roles            |
| ----- | ----------- | ------------------------ | ---------------- |
| Mary  | Admins      | AdministratorAccess      | AWS service role |
| John  | Developer   | DatabaseAdministrator    | EC2 instance     |

##### Permissions boundaries

- sets maximum permissions that an identity-based policy can grant to an IAM entity

#### Setting up your AWS credentials:

- Use AWS CLI to configure multiple _named profiles_.
- AWS CLI Priority order
  - Code or CLI
  - Environment variables: `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`
  - Default credential profile in the credentials file : `~/.aws/credentials`
  - Instance profile

```bash
# Configuring AWS credentials using AWS CLI

aws configure
# Add AWS Access Key ID
# Add AWS Secret Access
# Add default region name
# Add default output format

aws configure --profile user1

aws configure sso # using single-signon
```

#### Sign requests with credentials

| Why?                                 | How                                                                  |
| ------------------------------------ | -------------------------------------------------------------------- |
| Verify the identity of the requestor | Use HTTP Auth header                                                 |
| Protect data in transit              | Add query string value to the request                                |
| Protect against replay attacks       | SDKs automatically sign all requests with the credentials you create |

#### AWS Security Token Service (AWS STS)

- limited permissions
- temporary credentials for IAM users
  - User Federated User Service can gain temporary credentials by assuming a role (e.g. google/facebook)
- Not stored with requester
- Non-recyclable

## Module 5: Getting Started with Storage

### Amazon S3 Overview

- Amazon S3 is used for:
  - Content storage and distribution
  - Static website hosting
  - Backup andarchiving
  - Big data analytics
  - Disaster recovery
- Bucket needs to be globally unique across Amazon S3
- All buckets are encryped and private by default
- Amazon Storage services support these types of storage
  - File
  - Block
  - Object

#### S3 Components

```
                    |-----Service Endpoint----|--prefix--|--name---|
https://notes-bucket.s3.us-west-2.amazonaws.com/awsservice/notes.txt
       |-bucketname-|  |--region-|            |-------key----------|
                    |--| Service code
```

#### Features of Amazon S3

##### Notifications

- can configure S3 Event Notifications to publish events to:
  - Amazon Simple Notification Service (Amazon SNS) topics
  - Amazon Simple Queue Service (Amazon SQS) queues
  - AWS Lambda functions
  - Amazon EventBridge

##### Versioning

- Each object has a version ID
- Object locking is supported

##### Tags

- Tags are unique key-value pairs that attach to S3 as metadata
- Use cases:
  - Group objects
  - Cost allocation
  - Automation
  - Access control
  - Operation support and monitoring

##### S3 bucket policies

- Policy has five key elements
  - **Action**: Operations allowed or denied for each resource
  - **Resource**: Amazon Resource Name (ARN) defines the resource to which you allow or deny permissions
  - **Effect** - Allow or deny indicates whether the policy allows or denies access
  - **Condition**: specifies the conditions when the policy is in effect
  - **Principal**: Defines who the policy applies to

##### Access Points

- Unique hostnames and they are attached to buckets
- is configured with an access policy specific to the use case

#### AWS CLI S3 Commands

| Low-level commands (s3api)          | High-level commands s3)                  |
| ----------------------------------- | ---------------------------------------- |
| One-to-one mapping to Amazon S3 API | May result in multiple s3api invocations |
| Fine level control                  | Faster, but less control                 |
| `copy-object`                       | `cp`                                     |
| `create-multipart-upload`           | `sync`                                   |
| `complete-multipart-upload`         |                                          |
| `abort-multipart-upload`            |                                          |

```bash
# Basic AWS CLI S3 commands

aws s3 ls

aws s3 mb s3://lab-bucket
# make_bucket: lab-bucket

aws s3api list-buckets --query 'Buckets[].Name'
# [ 'lab-bucket', 'notes-bucket' ]
```

## Module 6: Processing your storage operations

### Create a bucket

1. Decide on a Bucket Name / AWS Region
   - Region should be closer to the consumer/client
2. Create a bucket
   - Check head-bucket info
   - Create the bucket
3. Verify bucket
   - creation by retrieving bucket information

```cs
# Verifying Bucket using .NET SDK

async Task VerifyBucketName(IAmazonS3 s3Client, string bucketName) {
    bool exists = false; // Check if a bucket already exists in AWS
    exists = await AmazonS3Util.DoesS3BucketExistV2Async(s3Client, bucketName);

    if (exists)
    {
        // DoesS3BucketExistV2Async returns true if the bucket exists, but that does not
        // necessarily mean it belongs to your account as the method catches AccessDenied
        // and other exceptions.

        Console.WriteLine("This bucket already exists in your, or someone else's, account.");
        Environment.Exit(0);
    }
    else {
        Console.WriteLine("The bucket does not exist.");
    }
```

#### Object operations

> Best Practices:
> You can upload or copy objects of up to 5GB in a single PUT operation.
> For larger objects up to 5 TB, you must use the multipart upload API.

- Upload
- List
- Download
- Copy
- Move
- Rename
- Delete
- Bulk operations
  - Copy
  - Sync
  - Batch

#### Multipart uploads

- It is a best practice to use aws s3 commands for multipart uploads/downloads
- Automatically performed based on the file size
- With multipart uploads
  - Upload parts in parallel to improve throughput
  - Recover quickly from network issues
  - Pause and resume object uploads
  - Begin an upload before you know the final size of an object

#### Retrieving data: `GET` and `HEAD`

- You can retrieve a complete object in a single GET request (`GetObject`)
- You can retrieve only the metadata/tags/sections of an object (`HeadObject`/`GetObjectAcl`/`GetObjectTagging`)

#### S3 `Select`

- analyzes/processes the data in an object in S3 bucket faster and cheaper than the GET method
- With `GET`, you retrieve the hwole object
- With `SELECT`, you retrieve a subset of data from an object by using simple SQL expressions

#### Presigned URL(Temporary permissions)

- All objects and buckets are private by defeault
- Presigned URLs allows you to GET/PUT without requiring AWS security credentials/permissions
- To create presigned URLs following must be provided

  - Security credentials
    - IAM user
    - IAM instance profile
    - AWS Security Token Service (AWS STS)
  - Bucket name
  - Object key
  - HTTP method (GET/PUT)
  - Expiration date and time

```cs
# Generating Presigned URL using .NET SDK

GetPreSignedUrlRequest request1 = new GetPreSignedUrlRequest
{
   BucketName = "notes-bucket",
   Key = objectKey,
   Expires = DateTime.UtcNow.AddHours(duration)
};
urlString = s3Client.GetPreSignedURL(request1);
```

#### Bulk Operations with `Copy` or `Sync`

```bash
# AWS CLI to perform bulk operations

aws s3 cp ./aFile.txt s3://<bucket-name>
          |--source-| |--destination---|
                                                 |------exclude-------|
aws s3 sync s3://source-bucket s3://other-bucket --exclude "*another/*"
```

#### S3 Batch operations

- performs large-scale operations on S3 objects

### Hosting a static website

```bash
# Enabling website hosting

aws s3 website s3://<bucket-name> --index-document index.html --error-document error.html
```

#### Cross-origin resource sharing

- CORS defines a way for client web applications that are loaded in one domain to interact with resources in a different domain
- to enable, create a CORS configuration XML file

```xml
<CORSConfiguration>
    <CORSRule>
        <AllowedOrigin>*</AllowedOrigin>
        <AllowedMethod>GET</AllowedMethod>
    </CORSRule>
</CORSConfiguration>
```

- [Using cross-origin resource sharing (CORS)](https://docs.aws.amazon.com/AmazonS3/latest/dev/cors.html)
- [CORS configuration](https://docs.aws.amazon.com/AmazonS3/latest/dev/ManageCorsUsing.html)
