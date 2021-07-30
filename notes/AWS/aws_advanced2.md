# Monolith to Microservices

##### Technical solution
- [x] ~~Deploy to AWS EB PaaS immediately~~
- [ ] __Migrate to microservices architecture__
- [ ] Use lambda
- [ ] Restructure organization around business capability
- [ ] Delegate ownership of each microservices to a dedicated team

## Microservices
- A way of designing software applications as suites of independently deployable services
- There is no precise definition of this architectural style, there are certain common characterisitics around organization around business capability, automated, deployment, intelligence in the endpoints and decentralized control of languages and data

`Amazon API Gateway` ==> `AWS Lambda`

### Find out the Core Domain / Sub Domain
- What is your core business goal?
  - e.g. Order => Invoice => Ship
- What is your sub domain?
  - e.g. Marketing / Search
- In order to process your core domain, what other process is required?
  - Ordering requires Customer / Product
  - Invoice requires Customer / Product / PayInfo
- Break down your core domains and sub domains to microservices

### Characteristics of microservices
- It isn't about size
  - How many people are employed to a team?
  - Keep your team small
- How is _micro_ 'micro'? How many is enough? How many is too many?
  - One microservice or Separate it into two?
- Similar to object-oriented code
  - You just need to pass `id` from a microservice to another!
- It's not only _technology_ change
  - Think of "How do each Microservices communicate each other?"(Data communication)
- Organized around business capability
- Decentralized ownership of services
- Automated deployment
- Intelligent endpoints
- Increased speed and agility
  - Small and focused changes
- Ability to innovate
  - Flexible Push / Rollback regularly
  - Easy to test
- Reduced cost
- Improved resilience
- Few lines of code
- Context mapping in DomainDrivenDesign
- Teams own their own state and do not share
- Has right technology stack for the job
- Small enough to be re-written

#### Tight Coupling
- The microservice A is using information B has
- A is always requesting from B and vice versa
- They need to be a single microservice

## Monolith vs Microservice

### Monolith
  - Horizontal
  - Simple deployments
  - Binary failure modes
  - Intermodule refactoring
  - Vertical scaling
  - Shared data store = One DB / One Application
  - Owned by everyone
  - On-Premisis servers or EC2 or Cloud
  - Complexity is in the codebase

  | Monolith Technology |                |      |
  | ------------------- | -------------- | ---- |
  | Presentation (UI)   | Business (API) | Data |

### Microservice
  - Vertical
  - Partial depoyments
  - Graceful degradation
  - Strong module boundaries
  - Technology diversity
  - Horizontal scaling
  - Discrete data stores
  - Owned by singel Dev or team
  - Serverless infrastructure
  - Complexity is in interaction and deployments
  - Web => Load balancer => Cloud Air UI => API Gateway => (Lamda => Service => Database)

  | Microservice Technology |                                     |
  | ----------------------- | ----------------------------------- |
  | Presentation (UI)       | Interface (API Gateway/SQS/Kinesis) |
  | Business (API)          | Lambda/Container/EC2                |
  | Data                    | DynamoDB /RDS/ Neptune              |

- Microservices organization (By business initiatives)
  - Simple Requirements
  - Flexible Tehcnology stack
  - Flexible Development
  - Better Quality
  - Easier Deployment
  - Organised Operations

## The evolution of Architecture
| Monolithic  | Service Oriented Architecture | Microservices |
| ----------- | ----------------------------- | ------------- |
| Single unit | Coarse-grained                | Fine-grained  |

##### The evolution of compute

| Pets           | Cattle               | Chicken                   | Microbes            |
| -------------- | -------------------- | ------------------------- | ------------------- |
| Physical (Tin) | Virtualization (VMs) | Containerization (Docker) | Serverless (Lambda) |

## AWS Lambda
- Lambda is a Serverless compute
- You don't have to think about
  - Servers
  - Being over/under capacity
  - Deployments
  - Scaling and fault tolerance
  - OS or language updates
  - Metrics and logging

##### Benefits
- Bring your own code
- Run code in parallel
- Create backends,event handlers, and data processing systems
- No fees for idle resources

### Domain-driven design and bounded context
- Microservices must have a well-defined bounded context and do only ONE thing
  - A bounded context encapsulates a single domain
  - A domain-driven design
    - defines the integration points with other domains
    - aligns well with characteristics of microservices
- Beware of creating monolithic microservices

### Microservices using Lambda and AWS API Gateway
- Amazon API Gateway
  - Create/publish,maintain,monitor, and secure RESTful APIs
  - Powered by `AWS content delivery network`
  - Provides `DDoS` protection and throttling capabilities
  - Multiple `API stages` that you define

|          | API           |         |
| -------- | ------------- | ------- |
|          | Step Function |         |
| Lambda A | Lambda B      | LambdaC |

- `Resources`
  - A logical entity that can be accessed in an API through its resource path
- `Methods`
  - The combination of a resource path and an HTTP verb, such as GET/POST/DELETE
- `Models`
  - Defines the format (schema or shape) of some data inbound or outbound from the API

##### SDK
- Generate SDKs from your API definition
  - API Gateway creates classes based on the models you define for your methods

##### Benefit
- Ability to create a unified API frontend for multiple microservices
- DDoS protection and throttling for backend systems
- Request authentication and authorization

- Native integration with AWS Lambda and Amazon Cognito for secure APIs
- APIs defined using the OpenAPI(Swagger) definition
- Part of the AWS SAM extension to AWS CloudFormation

## CDK (Cloud Development Kit)

### SAM (Serverless Application Model)
- It is a model to define serverless applications
- Defines simplified AWS CloudFormation syntax for expressing serverless resources
- `aws-sam-cli`
  - CLI deployment tool installed in local OR pipeline
  - Used to write a CloudFormation template
- AWS CloudFormation extension optimized for serverless application development
- Resource Types:
  - AWS Lambda funcitons
  - Amazon API Gateway APIs
  - Amazon DynamoDB tables
- Variables
  - AWS Lambda environment variables
  - API stage variables

##### SAM and CloudFormation
- AWS CloudFormation enables you to create and manage a collection of releated AWS resouces
- Supports
  - Change sets
  - CUstom resources

### AWS CloudFormation
1. ZIP the funciton files
2. Upload it to an S3 bucket
3. Add a `CodeUri` property, specifying the location of the zip file in the bucket for each functions in `appspec.yml`
4. Call the CloudFormation `CreateChangeSet` operation with `appspec.yml`
5. Call the CloudFormation `ExecuteChangeSet` operation with the name of the change set you created in step4

- Use the AWS CloudFormation package and deploy commands
  - `aws cloudfformation package --template-file app_spec.yml --output-template-file new_app_spec.yml --s3-bucket <your-bucket-name>`
  - `aws cloudfformation package --template-file new_app_spec.yml stack-name <your-bucket-name> --capabilities CAPABILITY_IAM`

### Strangling the monolith
- Reducing risk by using a strangler pattern rather than a direct cut-over
- Create a new microservice separate to existing monolith
  - Then add anti corruption layer
    - used as a means to communicate between bounded contexts
    - It translates from one context to the other, so that data in each context reflects the language and the way that context thinks and talks about the data

# Polyglot Persistence & Distributed complexity

## Distributed complexity Centralized Database
- Applicatinos often have a monolithic data store that is:
  - Difficult to make schema changes (BREAKING CHANGES)
  - Technology locked-in
  - Vertically scaled
  - A single point of failure
- e.g.
  - Multiple services talking to one database

## Polyglot persistence: Decentralized data stores
- Polyglot persistence
- Each service chooses its data store technology
- Low impact schema changes
- Independent scalability
- Data gated through the service API
- e.g.
  - Each service talking to its own databases

| SQL / NoSQL                      | Object              | Cache              |
| :------------------------------: | :-----------------: | :----------------: |
| Amazon RDS / Redshift / DynamoDB | Amazon S3 / Glacier | Amazon ElastiCache |

```
WEB <=> Elastic Load Balancing <=> CloudAir <==> API Gateway <==> ( Lambda <==> Service <==> DB )
```

## Amazon DynamoDB best practices
| SQL                   | NoSQL                   |
| --------------------- | ----------------------- |
| Optimized for storage | Optimized for compute   |
| Normalized/relational | Instantiated views      |
| Scale vertically      | Scale horizontally      |
| Good for OLAP         | Built for OLTP at scale |


## GSI / LSI (Global Secondary Index/ Local Secondary Index)
- You can attach GSI and LSI to a main database
- Primary Key
  - Partition Key
  - Sort Key

### Local secondary index
- Alternate sort key attribute
- Index is local to a partition key
- You can have maximum 5 LSI
- LSI is a separate data
- Has 10GB limit

Table
| A1(Partition) | A2(Sort) | A3  | A4  | A5  |
| ------------- | -------- | --- | --- | --- |
LSI
| A1(Partition) | A3  | A2  | KEYS_ONLY |            |     |
| ------------- | --- | --- | --------- | ---------- | --- |
| A1(Partition) | A4  | A2  | A3        | INCLUDE_A3 |     |
| A1(Partition) | A5  | A2  | A3        | A4         | ALL |

### Global Secondary Index
- Alternate partition and/or sort key
- Index is across all partition keys
- You can have maximum 20 GSI
- GSI is copy of the base data
- Read capacity units (RCUs) and write capacity units (WCUs) are provisioned separetly for GSIs

Table
| A1(Partition) | A2(Sort) | A3  | A4  | A5  |
| ------------- | -------- | --- | --- | --- |
GSI
| A2(Partition) | A1(Sort) | KEYS_ONLY |     |            |     |
| ------------- | -------- | --------- | --- | ---------- | --- |
| A5(Partition) | A4(Sort) | A1        | A3  | INCLUDE_A3 |     |
| A4(Partition) | A5(Sort) | A1        | A2  | A3         | ALL |

##### How GSI updates work

|        |                 |       |                                   |     |
| ------ | --------------- | ----- | --------------------------------- | --- |
| Client | Update Request  | Table | Asynchronous update (in progress) | GSI |
|        | Update Response |       |                                   |     |

##### LSI or GSI?
- You can model LSI as a GSI
  - If data size in an item collection > 10GB, use GSI
  - If eventual consistency is acceptable for your scenario, use GSI

### Amazon DynamoDB Accelerator (DAX)
- FUlly managed, highly available, in-memory cache
- Cluster based, Multi-AZ
- Support for AWS Java SDK
- Separate query and item cache

#### Comparison with traditional-side cache
- Traditional
  - App
    - <==> Cache
    - <==> Amazon DynamoDB
- Amazon DynamoDB Accelerator
  - App <==> DAX <==> Amazon DynamoDB

## AWS Step Functions
##### Challenge : Transacitonal Integrity
- Polyglot persistence generally translates into `eventual consistency`
- Asynchronous calls allow non-blocking, but returns need to be handled properly
- Transactional integrity
  - Event-sourcing-capture cahnges as sequence of events
  - staged commit
  - rollback on failure
  - loose coupling
- e.g.
  - API => Success => API 2 => Success => API 3 => FAILED! Rollback?

##### CAP Theorem
- It's impossible for a distributed computer system to simultaneoulsy provide all 3 of the following guarantees:
  - Consistency
  - Availability
  - Partition Tolerance
> In the presence of a network partition event
> we need to choose between _consistency_ and _availability_

##### Best Practices : Use Correlation IDs
- If async, use event-driven approach with DynamoDB Streams
- "Attach" yourself to data of interest
- Use clean-up functions
  - Amazon Kinesis: error streams
  - Amazon Simple Queue Service (SQS): error queue
  - Amazon Simple Notification Service (SNS): error notification
  - DynamoDB : error table
- If there was an error, call these clean-up functions
  - which then calls Transaction Manager function microservice
    - which then rolls back with correlation-id
- e.g.
  - API => Success (sends unique correlationid)
    - => API 2 => Success (sends unique correlationid)
      - => API 3 => FAILED! Rollback only for this correlationid!

### AWS Step Functions
1. Define a state machine workflow made up of states.
2. Start each execution with an input
3. Track the state of each execution
