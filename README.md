## AWS Data pipeline implementation with Terraform

### This terraform implementation has 6 components:
1. Creating Secrets Manager Key
2. Creating S3 buckets
3. Creating Lambda Functions for data extraction and glue crawler
4. Creating a glue ETL job
5. Creating RDS PostgreSQL database and a table
6. Creating a Step Functions workflow

#### Note: Use Windows PowerShell to run terraform commands

### Creating Sercets Manager Key
This key is used for storing the PostgreSQL database instance's password.
```
aws secretsmanager create-secret --name financialdb_password --secret-string "PasswordString"
```

Replace "PasswordString" with the password of your choice.

### For steps 2 through 6, run terraform commands
#### Initialize terraform working directory
```
terraform init
```

#### Validate terraform scripts
```
terraform validate
```

#### Preview terraform changes
```
terraform plan
```

#### Apply terraform scripts
```
terraform apply
```

#### Delete resources
```
terraform destroy
```
