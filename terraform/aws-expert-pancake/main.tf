terraform {
  backend "s3" {
    region         = "us-west-2"
    bucket         = "expert-pancake-tfstate"
    key            = "ep.tfstate"
    encrypt        = "true"
    dynamodb_table = "ep_tflock"
    acl            = "bucket-owner-full-control"
    profile        = "expert-pancake"
  }

  required_version = "= 0.12.9"
}

provider "aws" {
  region  = "us-west-2"
  profile = "expert-pancake"
}

module "expert-pancake" {
  source = "../resources"
}
