variable "region" {
  default     = "us-west-1"
  description = "AWS region"
}

variable "access_key" {

}

variable "secret_key" {

}

variable "db_name" {
}


variable "environment" {

  description = "Name of environment"

  default = "demo"

}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }
  }
}


provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = var.db_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  range_key      = "test_title"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "test_title"
    type = "S"
  }

  attribute {
    name = "TopScore"
    type = "N"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  global_secondary_index {
    name               = "test_title_Index"
    hash_key           = "test_title"
    range_key          = "TopScore"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}
