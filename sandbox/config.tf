provider "aws" {
  region = "${var.region}"
  alias = "SANDBOX"
  profile = "${var.profile}"
}

terraform {
  backend "s3" {
    bucket         = "trepp-genesis-terraform-statefiles"
    key            = "global/s3/sandbox/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

