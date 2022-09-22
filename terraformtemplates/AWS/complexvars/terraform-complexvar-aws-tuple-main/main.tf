provider "aws" {
 access_key = var.access_key
 secret_key = var.secret_key
 region     = var.region
}

resource "aws_ebs_volume" "awsEbsExampleWithTuple" {
  availability_zone = "us-east-1a"
  size              = var.sampleTuple[0]
  tags              = {
                        Name = var.sampleTuple[1]
                      }
}
