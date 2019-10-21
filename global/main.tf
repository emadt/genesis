provider "aws" {
  region = "${var.region}"
}

resource "aws_s3_account_public_access_block" "genesis" {
  block_public_acls   = true
  block_public_policy = true
}
resource "aws_s3_bucket" "terraform_state" {
   bucket = "trepp-genesis-terraform-statefiles"
   acl = "private"
   tags = {
     Name = "IaC"
     Environment = "genesis"
    }
   versioning {
     enabled = true
     } 
   server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket         = "trepp-genesis-terraform-statefiles"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
