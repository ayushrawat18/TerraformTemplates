variable "region" {
  default     = "us-west-1"
  description = "AWS region"
}

variable "access_key" {
}

variable "secret_key" {
}

variable "dbname" {}

provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_dynamodb_table" "example" {
  name             = var.dbname
  hash_key         = "TestTableHashKey"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "TestTableHashKey"
    type = "S"
  }

  replica {
    region_name = "us-east-2"
  }

  replica {
    region_name = "us-west-2"
  }
}
