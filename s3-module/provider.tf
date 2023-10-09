/*
provider "aws" {
  region = var.region
}
*/

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "landmark-automation-etienne"
    region = "us-west-2"
    key = "terraform.tfstate"
    #dynamodb_table = "control-tower-terraform-statelock"
    encrypt = true
  }

}
