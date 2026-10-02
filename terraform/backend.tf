terraform {
  backend "s3" {
    bucket = "ivolve-terraform-state-mahmoud-509989879328"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
