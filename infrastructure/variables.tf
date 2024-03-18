variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "eu-central-1"
}

variable "aws_az" {
  description = "Availability Zones for the AWS region"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
  default     = "default"
}

variable "app_name" {
  description = "Name of the app"
  type        = string
  default     = "wordpress"
}

variable "cidr_block" {
  description = "CIDR block for each subnet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "max_size" {
  description = "Max size of the K8s deployment"
  type        = string
  default     = "3"
}

variable "min_size" {
  description = "Min size of the K8s deployment"
  type        = string
  default     = "1"
}

variable "dbpassword" {
  description = "Password for RDS DB (Wordpress deployment)"
  type        = string
  default     = "password"
}
