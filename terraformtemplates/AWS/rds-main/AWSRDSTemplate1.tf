variable "region" {
  default     = "us-west-1"
  description = "AWS region"
}

variable "db_password" {
  description = "RDS root user password"
  default = "cmpdev123"
}

variable "access_key" {
}

variable "secret_key" {
}

variable "vpc_name" {
}

variable "subnet_name" {
}

variable "sg_name" {
}

variable "dbpg_name" {
}

variable "dbinstance_id" {
}

/*terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }
  }
}*/


provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = var.vpc_name
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-west-1a","us-west-1b"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}


resource "aws_db_subnet_group" "rds" {
  name       = var.subnet_name
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "test_db_subnet_group"
  }
}
resource "aws_security_group" "rds" {
  name   = var.sg_name
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test_rds"
  }
}

resource "aws_db_parameter_group" "rds" {
  name   = var.dbpg_name
  family = "mysql5.7"

   parameter {
    name  = "character_set_server"
    value = "utf8"
  }
}

resource "aws_db_instance" "test_db_instance" {
  identifier             = var.dbinstance_id
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  username               = "cmpdev"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.rds.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}
