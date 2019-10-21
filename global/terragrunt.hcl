remote_state {
  backend = "s3"
  config = {
    bucket         = "trepp-genesis-terraform-statefiles"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-up-and-running-locks"
  }   
}
prevent_destroy = true
