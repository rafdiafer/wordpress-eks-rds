terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "s3-tf-state-wordpress"
    dynamodb_table = "wordpress-dynamodb-tf-state-lock"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
  }
}