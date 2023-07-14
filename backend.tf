terraform {
  backend "s3" {
    bucket         = "sunking-assignment-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-state"
  }
}