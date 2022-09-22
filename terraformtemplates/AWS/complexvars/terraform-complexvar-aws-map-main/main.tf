# Sample Terraform Template with map (complex variable type)

provider "aws" {
 access_key = var.access_key
 secret_key = var.secret_key
 region     = var.region
}  


resource "aws_ebs_volume" "awsEbsExampleWithMap" {
  availability_zone = "us-east-1a"
  size = var.sampleMap["size"]
  tags = {
    Name = var.sampleMap["tag"]
  }
}
