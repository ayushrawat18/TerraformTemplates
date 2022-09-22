provider "aws" {
 access_key = var.access_key
 secret_key = var.secret_key
 region     = var.region
}

 resource "aws_ebs_volume" "awsEbsExampleWithObject" {
  availability_zone = "us-east-1a"
  size = var.sampleObject["size"]
  tags = {
    Name = var.sampleObject["tag"]
  }
}

