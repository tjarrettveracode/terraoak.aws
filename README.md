# TerraOak - Finding Design Gaps Daily
![TerraOak](oak9-logo.png)

TerraOak is [oak9](https://oak9.io)'s vulnerable Infrastructure as Code repository. This repo is for learning and training purposes to demonstrate how to implement a cloud security posture. 

## Table of Contents

* [Introduction](#introduction)
* [Scenario](#scenario)
* [Docker Setup](#running-inside-a-docker-container)
* [Terraform Code Execution](#terraform-code-execution)
* [oak9 CLI Execution](#oak9-cli-execution)


## Introduction 

Before proceeding, please read the following disclaimer:
> :warning: TerraOak is a repository of purposefully misconfigured commonly-used IaC with the intended purpose of showcasing oak9's powerful CLI and dynamic blueprint engine. Please use at your own discretion; oak9 is not responsible for any damages. **Do not deploy TerraOak in a production environment or against an AWS account that contains sensitive information.**

## Scenario

In this example, we'll build a simple user API using the following Amazon resources and secure them using oak9's platform:

* [Amazon S3](https://aws.amazon.com/s3/)
* [Amazon DynamoDB](https://aws.amazon.com/dynamodb/)
* [Amazon API Gateway](https://aws.amazon.com/api-gateway/)
* [AWS Lambda](https://aws.amazon.com/lambda/)

## Terraform Code 

One final word of warning: The IaC provided in this repository is vulnerable _by design_. These examples should **not** be executed to create resources in a production AWS account.

## Running oak9 inside a Docker container

* Pull most recent image from Docker Hub `docker pull oak9/cli`
* Pass the following environment variables to the container via `docker run` [-e or --env](https://docs.docker.com/engine/reference/commandline/run/#env) or your own Dockerfile
    * OAK9_API_KEY
    * OAK9_PROJECT_ID
    * OAK9_DIR = "\<directory containing Terraform files\>"

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

* Ensure a backend S3 bucket and DynamoDB table for Terraform state locking are created. This config will need to reside in a .tf file in the root directory. See Terraform's documentation for further details: https://www.terraform.io/language/settings/backends/s3

## Terraform Code Execution

* Clone or fork this repository
* Ensure [minimum version requirements](#requirements) are met 
* Run `terraform init`
* Run `terraform plan` or `terraform apply`
* Add an API user

`curl -X POST "$(terraform output -raw base_url)/set-user?id=0&name=john&orgid=xyx&plan=enterprise&orgname=xyzdfd&creationdate=82322"`

* Retrieve an API user 

`curl "$(terraform output -raw base_url)/get-user?id=0"`
 

## oak9 CLI Execution 

Instructions for downloading and running the oak9 CLI independent of Docker can be found here: https://docs.oak9.io/oak9/fundamentals/integrations/cli-integration
