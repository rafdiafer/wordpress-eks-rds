# AWS EKS: Wordpress + RDS (MySQL) Deployment

This is the solution to the "sys_eng_challenge" task, where the infrastructure needs to be defined to deploy a Kubernetes cluster, where Wordpress and its DB should be running and accessible from the outside.

AWS and Terraform were chosen for the task.

## Set up: Infrastructure and installation
There are two main folders:

### Services
This is where some services are defined to support Terraform:
* S3: Storing the Terraform State file.
* DynamoDB: Locking the Terraform file to prevent other team members to perform changes at the same time and corrupt it.

The following variables need to be defined:

| Variables     | Default Value | Description  |
| ------------- |:-------------:| :-----|
| aws_region      | eu-central-1 | AWS region for the infrastructure deployment |
| aws_profile      |  default      |   AWS Profile |
| app_name | phoenix      |    The name of the App |

The following commands need to be executed for these services to be provisioned:
```bash
$ terraform init
$ terraform plan
$ terraform apply
```

### Infrastructure
Here it is defined the infrastructure for the app, including all the modules needed.

First of all, before deploying the infrastructure, the backend needs to be defined in the backend.tf file
with the outputs information from the Services. As an example:

```
terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "s3-tf-state-phoenix"
    dynamodb_table = "phoenix-dynamodb-tf-state-lock"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
  }
}
```
The following variables need to be defined:

| Variables     | Default Value | Description  |
| ------------- |:-------------:| :-----|
| aws_region      | eu-central-1 | AWS region for the infrastructure deployment |
| aws_profile      |  default      |   AWS Profile |
| app_name | wordpress      |    The name of the App |
| aws_az | eu-central-1a, eu-central-1b     | Availability zones for the AWS region    |
| cidr_block |  10.0.0.0/16     |  CIDR block for the VPC  |
| min_size | 1      | Minimum number of the kubernetes deployment    |
| max_size | 3      | Maximum number of the kubernetes deployment   |
| dbpassword | -    | Password for RDS DB (Wordpress deployment) |

For provisioning the infrastructure, the following commands need to be executed:
```bash
$ terraform init
$ terraform plan
$ terraform apply
```

For cleaning the resources, the following command need to be executed:
```bash
$ terraform destroy
```

## Final solution

The services provisioned and the assumptions exmplanation are the following:
* A VPC with public subnets and private subnets, and two Availability Zones. The Kubernetes cluster will be in the private subnet, having access to the Internet through a NAT Gateway.
* An EKS Cluster with a Managed Worker Node group.
* A Wordpress deployment, also using Terraform (Bonus Point), that uses an RDS MySQL Database, communicating on port 3306. A Service creation of type LoadBalancer is also provided, which creates a LoadBalancer from AWS (ELB) and exposes the service on port 80.
* A Security Group for the RDS DB, allowing communication on port 3306, only from the Worker Nodes security group.

The reused code is the following:
* EKS Module: https://github.com/terraform-aws-modules/terraform-aws-eks
* VPC Module: https://github.com/terraform-aws-modules 

## Outputs

| Outputs     | Description  |
| ------------- |:-----|
| lb_hostname      | Load Balancer hostname to connect to the Wordpress app |

To add the Kubeconfig directly to your AWS CLI configuration, please execute the following command:

```bash
$ aws eks update-kubeconfig --name {cluster_name} --profile {profile_name}
```

## Progress

Regarding the 1h slot, I was able to fulfill the Part 1 and 2 of the task, taking into account the structured project, Services folder, and everything to make it work; and leaving out of that 1 hour some planning, some troubleshooting and the documentation.
