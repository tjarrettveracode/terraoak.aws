# TerraOak: Finding Design Gaps Daily
## Welcome to TerraOak-AWS!
![TerraOak](oak9-logo.png)

TerraOak is [oak9](https://oak9.io)'s vulnerable Infrastructure as Code repository. This repository contains deployable resource configurations for AWS, which have been intentionally designed to be insecure for learning purposes.

## Table of Contents

* [Introduction](#introduction)
* [Terraform Code Execution](#terraform-code-execution)
* [oak9 CLI Execution](#oak9-cli-execution)


## Introduction 
Before proceeding, please read the following disclaimer:
> :warning: TerraOak contains multiple examples of code displaying common IaC misconfigurations. These were developed with the intention of showcasing the impact of oak9's powerful CLI and dynamic blueprint engine on improving organizational security posture. Use at your own discretion; oak9 is not responsible for any damages.

 **Please use caution when using this codebase and ensure that you have appropriate permissions to deploy resources in your AWS environment. Always follow best practices for securing your cloud infrastructure and consult with your organization's security team before deploying any code to production environments.**

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

To view instructions for downloading and running the oak9 CLI independent of Docker please see the following documentation -> https://docs.oak9.io/oak9/fundamentals/integrations/cli-integration
