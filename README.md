## Cloud Foundry AWS Service Broker

Cloud Foundry Service Broker to manage instances of various AWS services.

### Current Services Supported
- RDS

### Setup

#### Environment Variables
There are important environment variables that should be overriden inside the `manifest.yml` file

> Note: All environment variables prefixed with `DB_` refer to attributes for the database the broker itself will use for internal uses.

1. `DB_URL`: The hostname / IP address of the database.
1. `DB_PORT`: The port number to access the database.
1. `DB_NAME`: The database name.
1. `DB_USER`: Username to access the database.
1. `DB_PASS`: Password to access the database.
1. `DB_TYPE`: The type of database. Currently supported types: `postgres` and `sqlite3`.
1. `DB_SSLMODE`: The type of SSL Mode to use when connecting to the database. Supported modes: `disabled`, `require` and `verify-ca`.
1. `AWS_ACCESS_KEY_ID`: The id credential with access to make requests to the Amazon RDS .
1. `AWS_SECRET_ACCESS_KEY`: The secret key (treat like a password) credential to access Amazon RDS.
1. `AWS_DEFAULT_REGION`: Region you wish to provision services in.
1. `AUTH_USER`: The username used by cf to authenticate to the broker
1. `AUTH_PASS`: The password used by cf to authenticate to the broker
1. `ENC_KEY`: This is an string that must be 16, 24, or 32 bytes long.  It is an AES key that is used to encrypt the password.

> Note the AWS Environment Variables should be generated by following the instructions [here](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html)

> Make sure the account has write access to RDS and EC2 (particularly for VPC and Subnet). 

> Example of permissions that suffice: `AmazonRDSFullAccess` and `AmazonEC2FullAccess`

> You may need to adjust VPC routing, security groups, public accessibility (DNS names, etc) as well, depending on your needs.

#### Optional Environment Variables

There are some feature flags that you can turn on as well:
1. `ENABLE_FUNCTIONS`:  This will enable users to create mysql databases like 
   `cf create-service _servicename_ production my-mysql-service -c '{"enable_functions": "true"}'`,
   which will set the `log_bin_trust_function_creators=1` parameter for their db,
   enabling the creation of functions in their databases.
1. `PUBLICLY_ACCESSIBLE`:  If this environment variable exists, databases that are created by the broker
   will be created with `PubliclyAccessible: true`.  This is probably not something you want to set unless
   you really know what you are doing.

#### Catalog.yaml

Catalog.yaml contains a list of service(s) offered with plans. It contains no secrets.
Prior to pushing, complete the catalog.yaml for your environment. It is architected where the service name (e.g. rds) is the mapping between it and the service details.

#### Secrets.yml

secrets.yml contains the all of the secrets for the different resources. 


### How to deploy it

1. `cf push`
1. `cf create-service-broker BROKER_NAME AUTH_USER AUTH_PASS https://BROKER-URL`
1. `cf enable-service-access SERVICE_NAME`

In this case BROKER_NAME would be `aws` and it would contain many service names (one for `rds`, one for `s3`). Then SERVICE_NAME would be `rds` for example.

### How to use it

To use the service you need to create a service instance and bind it:

1. `cf create-service SERVICE_NAME shared-psql MYDB`
1. `cf bind-service APP MYDB`

When you do that you will have all the credentials in the 
`VCAP_SERVICES` environment variable with the JSON key `rds`.

Also, you will have a `DATABASE_URL` environment variable that will
be the connection string to the DB.

### Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
