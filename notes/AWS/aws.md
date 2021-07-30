# AWS

## AWS Cloud Computing
- Borrowing someone else'sinfrastructure
- No need to worry about hardware/security/redundancy etc.

### Benefits
- Pay for what you use as you go
- Data driven capacity
- Increase speed and agility => Focus on customers and market value
- Low costs of ownership (Maintaining fees)
- Go global and deploy in minutes

## AWS Foundation Services

- Compute
  - EC2
    - Pay as you go
    - Create AMI (Amazon Machine images)
    - Add/Terminate/Pause/Resume instances as needed
- Networking
  - Elastic load balancing
    - Distributes traffic among multiple ec2 instances in different zones
    - Healthchecks (Removes unhealthy instance)
    - Sticky sessions
      - Bind user's session to specific server instances
      - limit app's scalability
      - Unequal load across servers impacting response time
  - SQS (Simple Queue Service)
    - connect systems or applications
  - EC2 auto scaling
    - Set up based config with:
      - desired quantity
      - scale out / scale in
      - manual scaling
  - Storage
    - Simple storage service (s3)
  - Management tools (watch/trail/formation)

#### Managed vs Unmanaged services

##### Managed
- Auto scaling
- Fault tolerance
- Built in availability (rds)
- No more heavy lifting

##### Unmanaged
- You do all the heavy lifting
- Manage scaling
- Fault tolerance and availability
- Set up backups
- Manage patching

## Cloud Scenarios

### Cloud Deployment Models?

##### All in cloud
- Lift and `shift`

##### Hybrid
- Customer using aws services in the cloud but have ERP(enterprise resource planning) system on premises

### Microservices

- `Input` => `Process` => `Output`
- Process __*__
  - It takes `inputs` => generates `outputs`
  - It has an independent specific function
- Break services apart into self sustained modules
- Benefits
  - Agility / Flexible scaling / easy deployment / Technology freedom / Resusable code / Resilience (Circuit breaker pattern)
- Serverless

#### When choosing a sceneario
- Start at the most abstract layer
- Start at lambda and then move down
- `ec2 => ecs => lambda`
- `vm => task => function`
- `hardware => os => runtime`

## Infrastructure overview

### AWS Data Center

- Typically houses thoudsands of servers
- All data centres are online
- If the server goes down?
  - A single data center is not fault tolerant enough
  - AWS has availability zones

### Availability zones

- Typically more than one data center
- Designed for fault isolation
- Data centers have fibre links and interconnected with other availability zones
- Regions have a minimum of 2 zones based on geographic locations (Sydney has 3 AZ)
- If you put something in a region, then it will not leave the region unless specified
- Take as many precautions as possible for resiliency
- Deploy your apps into multiple availability zones
  - Could have active and standby but you'd have manage redundancy to have fault tolerance and high availability
- Important to know if we are deploying within a region or a zone
- How do you pick a region?
  - Pick something close to your consumers (latency & performance)
  - Any constraints on data governance
  - Any legal requirements


# Developing on AWS

#### How to get AWS Credentials
- `IAM` : Setup user and policies
- Add user/ Choose programmatic access and no permissions
- `Access key` ( username )
- `Secret Access key` ( password )

#### Dev tools
- Cloud9 (ide)
  - Easy way to collab on code
  - avoids cumbersome setup of dev env
- AWS toolkit for VS
- sdks: `boto3`(python), `.net`, `java`
- cli: `awscli`, `sam`
- `aws xray`
  - important tool for microservices architecture
  - can crate service map

#### Management tools
- cloudwatch
  - collect/track metrics
  - monitor and store logs
  - set alarms and act on them (create pagerduty ticket, call lambda)
  - view stats and graphs
- cloudtrail
  - auditing tool
  - record api calls
  - good troubleshooting tool

#### Connecting to service
- Service client API (e.g. s3)
- Resource API: Defines service resources and individual resources

#### Working with regions
- Specify region when instantiating service client
- Specify default region

#### AWS service exceptions and errors
- 400 series
  - client side (handle error in app)
- 500 series
  - server side
  - allow retry operation but could end up with throttling problem so allow retry with exponential backoff
  - create error handler and have a count and backoff
  - create a support case immediately using api
- Design apps to expect errors
  - e.g. Check if s3 bucket exists => if not then create it
  - expect it to fail and know how to handle error
- java/.net sdk
  - `AmazonClientException`
  - `AmazonServiceException`

#### Best practices for developing
- Consider designing apps that are loosely coupled
- Architect for resilience, design for failure
- Log metrics & monitor performances
- Implement security in every layer


# AWS Identity & Access Management (IAM)

#### Shared Responsibility Model
##### Customer responsibility (What's in the cloud)
  - customer data
  - platform
  - apps
  - identity and access management
  - os
  - network
  - firewall
  - encryption
  - network traffic protection
##### AWS responsibility
  - cloud
  - foundation
  - global infrastructure

## IAM

#### Identity & Access Management
- Authentication: "who"
- Authorization: "can/can't do"

#### User
- Are IAM users always needed?
- What is an existing IAM user temporarily needs special privileges
- What if identities exist outside of AWS?
- Can temp access be assigned?
- Do all users need permanent identities in IAM? NO
- If temporary => use ROLES

#### Groups

#### Roles
- Set of permissions one can assume like taking on a persona but doesn't change identity

#### Permissions
- Identity based permissions
  - Identifies who is using it using c.a.r.e
- Resource base permissions
  - Protects the resource itself
  - Apply policy to resource using c.a.r.e
    - e.g. Deny admin user to HR folder in S3 bucket
      - Condition: range on premises
        - Action : *
        - Resources : s3/hr
        - Effect : Allow
        - Principle : hr
      - Condition: -
        - Action : *
        - Resources : s3/hr
        - deny : Allow
        - Principle : !hr

#### Policy
- C.A.R.E about security
- Condition
  - which conditions met for authorization
- Action
  - which task is allowed?
- Resource
  - which resource can be acted on based on this policy
- Effect
  - allow or deny?
- Ambiguity will not be tolerated
- Policy Types
  - inline :
    - embedded in an entity
    - can't manage
    - not version controlled
    - not reusable
  - managed:
    - can be attached to multiple users/groups/roles
    - reusable
    - version controlled
    - central change management
  - AWS Managed
    - start here and create customer managed policy based on aws managed policycustomer managed

##### Best Practices
- Apply policies to groups
- Use principle of least privilege
- Evaluation logic
  - Evaluate all applicable policies
  - Explicit deny always wins
  ```
  if !deny
    if !allow
      DENIED
    else
      ALLOWED
  else
    DENIED
  ```

#### Resources
- `arn:aws:service:region:account:resource-id`


## User Authentication and Authorization

### Authentication
- Types
  - AWS auth: username/password
  - Application auth: access key/secret key
  - Resources auth: access key/secret key
  - DV auth: access key/secret key
- Do
  - Use MFA for extra security
  - Keys are stored in flat file (keys can get compromised if machine is compromised)
  - Use temp creds from AWS security token service (valid from 15min ~ 12hrs)
  - Use IAM roles (preferred)
- Do not
  - Use root account creds (Root is not an IAM user and does not get policies applied)
  - Put AWS creds in code
  - Store creds in public places
- Creds profile file:
  - `~/.aws/credentials`
- Configs
  - `~/.aws/config`
- Env vars
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
- Priority order
  - Specified in code
  - env vars
  - creds file
  - EC2 instance role
- Sign requests with credentials
  - Verifies identify of requester
  - Protects against replay attack
  - Protects data in transit
  - Use auth header/query string values to requests
  - SDKs will automatically sign all requests with creds you setup
- Troubleshooting
  - Access denied
    - Verify permission for action on resource
    - Verify conditions are met
    - Verify resource policies
  - Check Cloudtrail


# Developing Storage Solutions with Amazon S3

#### Glacier
- Used mainly for:
  - data archiving
  - backups
- It's a cold storage
- It has multiple options to retrieve data

#### EFS (Elastic File System)
- Highly scalable file system

#### EBS
- Network attached storage
- persistent storage
- Use case : RDB / stream and log processing applications
- Block storage

#### S3
- Independent of a server
- API Access / Accessible via HTTP
- Store large amounts of data cost effectively
- Scalable
- Data replicated across zones to ensure high availability
- 99.99999999999 durability
- Object size can range from 0 bytes - 5 Terabytes
- Use case: Backups / Archiving / serve static content
- Configuration:
  - Bucket names :
    - relevant to you
    - must be DNS compliant
    - unique with the S3 network
  - Choose region by taking latency/cost into account (Can use Cloudfront)
  - Private by default
  - Can enable versioning but will affect storage costs
  - Can tag buckets to apply policies
  - Can enable encryption
- Can set metadata for objects
- Keys are unique identifier for each object
- No object hierarchy
- Each object has a URL
- Can control object permissions using ACL(Access Control List : resource based policy)
- Should use bucket policy instead of going granular to object level policy
- When objects are deleted, a marker is added but it's not actually deleted
- Can use multi-part uploads for large objects
  - need to use upload-id when using the upload-part command
  - SDKs provide this functionality by default
- Can share objects with users without having to make buckets and objects public
  - Done by presigning objects using the X3 presign command with expiration time
- Data integrity
  - Verify the integrity by checkign the md5 hashes of the objects
  - Query objects with the `s3-select` command
- Performance
  - Avoid unnecessary requests
  - Handle NoSuchBucket errors
  - Set object metadata before uploading the object
  - Avoid using copy operation to update metadata
  - Cache bucket and keynames if your app allows it
- Troubleshooting
  - Check permissions
  - Enable SDK logging & Server Access logging
  - Handle error and exceptions gracefully
