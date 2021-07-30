# Advanced Developing on AWS

## The Cloud Journey

### Introduction to Cloud Air
- Global Infrastructure
  - Regions ( Cloud )
    - AV (Availability Zones)
      - Data Centers : 100km away Data Centers to another
        - PoPs (Point of Presidencies) / Edge Locations : connects to multiple Data centers
- Upload on S3 bucket in your edge locations => Data centers pick them up => Distributes to AV => Distributed to Regions
- 24 Regions

#### Availability Zone / Region Separation
- An app can execute a lambda functions in multiple AZ
- E.g. Same region
  - Application in AZ 1
  - Database server in AZ 2
  - Single digit ms latency between AZ
  - Tens-of ms latency between regions
- E.g. Master DB and Replica DB
  - Application and Master DB in AZ1
  - Application and Replica DB in AZ2
  - Both Applications talks to Master DB
  - Master DB replicates data to replica DB

#### Common on-premises architecture
  - They do not scale easily!
  - `Single vertically scaled server hosted off-cloud` ➡️ `Single vertically-scaled DB hosted off-cloud`
  - Slow release cycle / Too much change / Hard to roll back
  - One single executable used to run everything
    - Business growth was too fast to keep up
    - Cross-team coordination + maintenance => Innovation
    > "Innovation is now recognized as the `single most important ingredient` in any modern economy.
    > In short, it is innovation - more than the application of capital and labor - that makes the world go round"
  - How do we need know when to make a transition?
  > "A compelling event (e.g. licence expiration/regional legal issues) some technical debt, and a big business opportunity"

##### Benefits
    - Low latency
    - One runtime

##### Technical Problems
    - Monolithic codebase (one language!)
    - Stateful application logic
      - States are stored locally which can be lost in different instance
    - Tight coupling
    - No separation of concerns
    - Performance issues
    - Maintenance difficulties
    - Implementation detail leakage in the API
    - Data tier complexities
    - Lots of undifferentiated heavy lifting

##### Solution
    - Cloud infrastructure introduces new concepts
    - Off-cloud design doesn't always translate to cloud principles
    - Lift and shift often limits the value proposition
    - but addresses our time constraints for the compelling event
    - Applications that don't embrace cloud-native design don't fully realize
      - Scalability
      - Availability
      - Cost benefits
    - Cloud design principles are still emerging!

### Migration to the Cloud
  - Why?
    - go faster
    - be more stable
    - increase quality

##### A Good Architecture
  - One Monolith, many components communicating with
    - ➡️ Cold/hot read/write master
    - ➡️ Single vertically-scaled server hosted on-premises

#### Guardrails
- Good reference books: Books by Sam Newman
  - Monolith to Microservices and Building Microservices
- How do I know that I am building a cloud native application? What are the indicators?
- Use 6R's of migration

### The 6R's of migration
##### Retain
- Keep host/application in source environment
- Minimal analysis/validation of scope & application affinity
  - On-premises application
  - Break them into different concepts / business models
##### Retire
- Decommission
- No migration of application
##### Rehost
- Like-for-like app migration to AWS
- Lift-and-shift approach
- Minimal effort to make the app work 'in' the cloud or take advantage of cloud native services
##### Replatform
- Up-version the OS/DB
- Make use of Amazon RDS (Relational Database Service)
- Some app changes
- App re-installation and clean-up
##### Refactor
- OS/DB porting
- MIddleware and app changes to use AWS services natively
- Data conversion & DB transition
##### Rearchitect
- Application architecture changes
- Using SaaS-based offerings
- Porting of application architecture
- Data modernization, application consolidation, use AWS native managed services
##### Technical Solution
- Deploy to AWS Elastic Beanstalk PaaS immediately
- Migrate over time to a microservices architecture
- Use AWS lambda to host our microservices
- Restructure organisation around business capability
- Delegate ownership of each microservices to a dedicated team

### The 12-Factor App methodology
- Best practices for developer and operations engineers
- Used for building _software-as-a-service_ app (_web apps_)
- Some guidelines align with best practices for serverless applications such as :
  - AWS Lambda
  - Amazon API Gateway
  - AWS Step Functions
- Can be applied to apps written in any programming language, and which use any combination of backing services (db, queue, memory cache, etc.)
> Use declarative formats for setup automation, to minimize time and cost for new developers joining the project;
> Have a clean contract with the underlying operating system, offering maximum portability between execution environments;
> Are suitable for deployment on modern cloud platforms, obviating the need for servers and systems administration;
> Minimize divergence between development and production, enabling continuous deployment for maximum agility;
> And can scale up without significant changes to tooling, architecture, or development practices. [12factor.net](https://12factor.net/)
- Minimize the effort of new developer setup
- Maximize the portability of the application
- Deploy applications easily to modern cloud platforms
- Maintain environment parity between development and production

1. Codebase
  - One repo / one source / one codebase
  - dev branch => dev environment / master branch => master environment
2. Dependencies
  - Maintain single module for all environments
  - Insert the modules into build-pipeline
3. Config
  - Use config to to toggle environments
  - Separate to source code / pipeline
4. Backing services
5. Build, release, run
6. Processes
7. Port binding
  - Should be handled by service (lambda)
8. Concurrency
  - Should be able to run multiple lambda/container/ec2
  - all services should be serverless
9. Disposability
  - should be scalable and disposable
10. Dev/Prod parity
11. Logs
  - Centralised logging system (e.g. CloudWatch)
12. Admin processes

##### Technical Solution
- Introduce automation deployment
- Use pipelines for build and deploy
- Each microservice will designed for suitable applications
- Quality increased by
  - Testing during build
  - Visibility into app performance with AWS X-Ray
    - AWS X-Ray visualises the complexity between microservices
  - Logging via Amazon CloudWatch metrics and CloudWatch logs

### Architectural styles and patterns
- Monolith
  - N-Tier pattern
  - Vertical layer
- Service-oriented architecture
- Microservices
---
- MVC
  - Model / View / Controller
  - Usually for Web frontend
- Publisher-Subscriber
  - Publishers => Queue
  - Subscriber => Queue
- CQRS (Command Query Responsibility Segregation)
  - Service or Application => Funciton or method => Query => Read => Materlized View
  - Service or Application => Funciton or method => COmmand => Write => event sourcing => Materlized View

#### Interfacing with AWS services
- Low-level APIs:  Developers have full control over behaviour
- High-level APIs: abstract complex flow for common tasks

### Authentication and authorization
- All interactions are signed with `AccessKeyId` and `SecretAcessKey` using sigv4
- `AccessKeyId` and `SecretAcessKey` map to users or roles in AWS Identity and Access Management (IAM)
- The _default credential provider chain_ looks for credentials in this order:
  1. Specified in the code
  2. Environment variables
  3. Default credential profile in the credentials file
  4. Amazon ECS container credentials
  5. Amazon EC2 instance role
- Permissions boundaries for IAM entities
- How do users/applications authenticate?
  - If running in an IDE, add credentials to the AWS Toolkit setup
  - If using the AWS Management Console, sign in as an IAM user
  - Amazon Cognito vends scoped, temporary crednetials to untrusted environments such as web and mobile apps

##### Using `--profile`
- Use `--profile` to target multiple AWS accounts from the AWS CLI or your source code.
  - Labs
    - Create or update the `aws-lab-env` profile
  - Subsequent API calls
    - `aws lambda create-function --function-name`
    - `someFunctionName --profile aws-lab-env`

### Infrastructure as code and AWS Elastic Beanstalk
- Everything is code in the cloud
- Software Defined Everything (SDE)
  - Everything is treated as a software
- Elastic BeanStalk will generate simple CloudFormation template which builds an environment
- Great way to deploying an instance to a cloud

##### AWS CloudFormation
- JSON/YAML formatted file => Framework => Configured AWS services

##### Foundation Architecture
- Virtual private cloud
- Public and private subnets
- Routing
- NAT instances
- Security groups

# Gaining Agility
- Why do we use DevOps?
  - Developers and Operations were separate
  - No communications between two teams
  - Development and Operations come together => DevOps
- Infrastructure as code (AWS makes this easy!)
  - Application and Infrastructure version management
    - Continuous integration
    - Test automation
    - Continuous deployment
    - Monitoring and logging

## Continuous Integration and Continuous Deployment (CI/CD)
- Every code check-ins initiates builds
- Repo (develop) => Build/Test (CI)
- Repo (master) => Build/Test (CD)
- Implementation/Test Cycle
  - Build => Unit Test => Integration Test => Systems Test
- Deployment Cycle
  - Development => Staging => QA => Production
  - Never let defects pass Development phase!
- Benefits:
  - Instant feedback for developer

#### AWS Config
- Store config in the environment!
- A 12-Factor App strictly separates config from code
- Config
  - Includes variations between deployments
  - Excludes internal configurations such as routes

#### AWS Secrets Manager
- You can keep secret values in the vault
- Rotate, manage, and retrieve database usage

#### Parameter Store
- used to store credentials
- better to use secret manager if you want the ability to rotate creds

#### AWS Systems Manager
- Service features:
  - Securely encrypt, store, and retrieve credentials for your databases and other services
  - Scheduled rotation with conrol over rotation logic via Lambda function
  - Connection strings, key-value pairs, JSON etc.

### 4 Phases of release process
1. Source (CI/CD)
  - Check-in source code such as java files
  - Peer review new code
2. Build (CI/CD)
  - Compile code
  - Unit Tests
  - Style checkers
  - Code metrics
  - Create container images
3. Test (CD)
  - Integration tests with other systems
  - Load testing
  - UI tests
  - Penetration testing
4. Production (CD)
  - Deployment to dev / staging / UAT / Production environments

### Benefits of CD
- Automate the software release process
- Improve developer productivity
- Find and address bugs quickly
- Deliver updates faster

### AWS Code___
- CodeStar
  - Quickly develop/build/deploy application
- CodeArtifact
  - Secure/Scalable and cost effective artifact management
- CodeCommit
  - Store code in private git repo
- CodeBuild
  - Build and Test code
- CodePipeline
  - Release software using CD
- CodeDeploy
  - Automate code deployments
