# lambda-thumbnail-generator

Simple AWS S3 photo gallery with a Python lambda function to generate thumbnail

## How to install

### 1. Adjust the configuration

Edit the `terraform/terraform.tfvars.example` and remove the `.example` suffix.

### 2. Create lambda function ZIP

```
./lambda/package.sh
```

A zip file `lambda/lambda.zip` will be created. Terraform will upload it to AWS.

### 3. Create AWS ressources (lambda + S3) with Terraform

```
export AWS_DEFAULT_REGION="eu-west-3"
cd terraform
terraform init # only the first time
terraform plan
terraform apply
```

## Known limits

* **The S3 bucket should be public** (⚠️ Terraform apply a `AllowPublicRead` policy on the bucket) 
* Photo filename should have `.jpg` suffix
* Photo filename should **not** contains space
* Photo filename should **not** begin with the thumbnail prefix (*thumb_*)