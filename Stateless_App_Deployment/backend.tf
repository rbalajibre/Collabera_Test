terraform {
  backend "s3" {
    bucket         = "terraform-lab-test-tf-state"
    key            = "lab1/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}