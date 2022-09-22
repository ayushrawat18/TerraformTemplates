provider "aws" {
 access_key = var.access_key
 secret_key = var.secret_key
 region     = var.region
}

resource "aws_ebs_volume" "awsEbsExampleWithList" {
  availability_zone = "us-east-1a"
  size              = var.ebsSizes[0]
  tags              = {
                        Name = var.sampleTags[1]
                      }
}
