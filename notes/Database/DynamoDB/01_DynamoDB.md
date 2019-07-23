# Amazon DynamoDB

- No SQL Database service from Amazon
- Create AWS Account
- IAM => Users => Create user => Security Credentials => Create access key
- Run `brew install aws-cli`
- Run `aws configure` and paste in accessID and secret
- Run `cat ~/.aws/credentials` to see profile
- Run `cat ~/.aws/config` to see other configs

### To use Local DynamoDB with Docker
```bash
docker run --rm -it -p 8000:8000 amazon/dynamodb-local
```

### Use Amazon SDK to connect with database in node app

```bash
npm install aws-sdk
yarn add aws-sdk
```

```javascript
const aws = require('aws-sdk')

aws.config.update({
  region:'YOUR REGION (e.g. ap-southeast-2)',
  //if localhost
  endpoint-url: 'http://localhost:8000'
})
```
