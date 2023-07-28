# README #

This repository contains an example set of [Terraform](https://terraform.io) manifests for building a basic Drupal at AWS.

### What does it do? ###

* Provisions AWS security groups
* Provisions a VPC (private network at AWS)
* Provisions an RDS instance with a Drupal database
* Provisions an EC2 instance (for your Drupal app)
* Installs Drupal and relevant dependencies on the EC2 instance

At the end you should have a vanilla latest Drupal instance up and running at the endpoint provided in the output.

### To run in your local ###
#### Prerequisites ####
* Create an AWS Account (https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)
* Setup AWS CLI in your local environment (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* Create an access key from the security credentials (https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html)
* Configure access key and Secret keys using 'aws configure' for authentication and configuration (https://docs.aws.amazon.com/cli/latest/reference/configure/)
* Install terraform in your local environment (https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* Clone this repository and navigate to `terraform` directory
* Adjust variables.tf if you wish (e.g to change the SSH key, EC2 size, or region to deploy in)
* Run `terraform init` and followed by `terraform apply`
##### The above steps will spin up all the required resource in your AWS console and install a vanilla Drupal. Go to your AWS Console EC2 service and get the details of your server. More info - https://aws.amazon.com/ec2/
#####
##### You will notice `terraform.tfstate` auto generated inside your terraform directory. This is where terraform knows what's the current state of the infrastructure #####

### Tear up the infrastructure ###
* Run `terraform destroy` to delete all the resources that's built. It uses the terraform.tfstate file to get the information about the current infrastructure state.

### Leverage S3 bucket as terraform backend state ###
* Checkout to branch `s3-backend`
* In `terraform/profider.tf` file you will notice `backend s3` defined within `terraform` block. This is to let terraform know to capture its backend state in the specific s3 bucket.
* Go to AWS console and create an s3 bucket for storing your terraform state (https://docs.aws.amazon.com/AmazonS3/latest/userguide/creating-bucket.html)
* Run `terraform init` within the terraform directory and specify the S3 bucket region (ap-south-1) in my case.
* Run `terraform apply`
* This will once again create the same set of resources that was provisioned before. But the major change in terraform states is the use of S3 bucket we created to store the states file.
* Once the apply is done, navigate to the newly created S3 bucket and notice a new file created.
* Run `terraform destroy` to delete all the resources that's built. It uses the S3 bucket terraform.tfstate file to get the information about the current infrastructure state.

### Automate with Azure pipelines ###
* For CI/CD pipelines we are using Azure Devops (https://www.azuredevopslabs.com/labs/vstsextend/terraform/)
* Create a new Azure git repository in your Project.
* Create a new git remote and set the newly created Azure repository as a remote. More info - https://learn.microsoft.com/en-us/azure/devops/repos/git/create-new-repo?view=azure-devops
* Create a new Service Connection to AWS in Azure Devops with the access key and secret keys that you've generated earlier, and the AWS region. More info - https://learn.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure?view=azure-devops
* Checkout to branch `azure-pipelines`
* Configure bucket name and `backendServiceAWS` (Service Connection Name) in the "provider.tf" file and also in the "azure-pipelines.yml"
* Commit and push the changes to the new git remote. You will see a new Pipeline triggered under `Pipelines`
* The build will internally run `terraform plan` and `terraform apply` commands and will once again spin up all the earlier mentioned resources and install a vanilla Drupal.

### Tear up the infrastructure with Azure pipelines ###
* Checkout to `destroy` branch.
* Configure bucket name and `backendServiceAWS` (Service Connection Name) in the "provider.tf" file and also in the "azure-pipelines.yml"
* Commit and push the changes to the new git remote. You will see the build generated on the pipeline.
* This time the `terraform destroy` command executes and will destroy all the resources.

### Terraform Commands ###
* terraform init
* terraform validate
* terraform plan
* terraform apply
* terraform destroy

### Troubleshoot ###

╷
│ Error: error configuring S3 Backend: no valid credential sources for S3 Backend found.
│ 
│ Please see https://www.terraform.io/docs/language/settings/backends/s3.html
│ for more information about providing credentials.
│ 
│ Error: NoCredentialProviders: no valid providers in chain. Deprecated.
│ 	For verbose messaging see aws.Config.CredentialsChainVerboseErrors
│ 
│ 
│ 
╵
* Ensure if AWS is authenticated and configured while running `terraform init` locally. More info here - https://registry.terraform.io/providers/hashicorp/aws/latest/docs


╷
│ Error: Incompatible provider version
│ 
│ Provider registry.terraform.io/hashicorp/template v2.2.0 does not have a package available for your current platform,
│ darwin_arm64.
│ 
│ Provider releases are separate from Terraform CLI releases, so not all providers are available for all platforms. Other
│ versions of this provider may have different platforms supported.
╵
* This is typically found when initializing terraform on a Macbook M1 chip. Solution is to use `m1-terraform-provider-helper`. More info and steps -  https://kreuzwerker.de/en/post/use-m1-terraform-provider-helper-to-compile-terraform-providers-for-mac-m1

╷
│ Error: No configuration files
│ 
│ Apply requires configuration to be present. Applying without a configuration would mark everything for destruction, which is
│ normally not what is desired. If you would like to destroy everything, run 'terraform destroy' instead.
╵
* Ensure `terraform init` is executed from within `terraform` directory. Subsequent terraform commands should be executed within the `terraform` directory.



### What else can I do with Terraform? ###

A lot more. See the [Terraform docs](https://terraform.io/docs/).
