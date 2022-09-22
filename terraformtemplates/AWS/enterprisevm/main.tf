#File =/provider.tf
provider "aws" {
  access_key          = "${var.access_key}"
  secret_key          = "${var.secret_key}"
  region              = "${var.region}"
  version             = ">= 3.0"
}

variable secret_key {}

variable access_key {}

variable token {}

#File =/resources.tf
resource "aws_vpc" "vpcByTFE" {
  cidr_block  = "10.0.0.0/16"
}

resource "aws_subnet" "subnetByTFE" {
  vpc_id      = "${aws_vpc.vpcByTFE.id}"
  cidr_block  = "10.0.1.0/24"
}

resource "aws_network_interface" "nicByTFE" {
  subnet_id = "${aws_subnet.subnetByTFE.id}"
}

resource "aws_instance" "ec2ByTFE" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  
  network_interface {
    network_interface_id = "${aws_network_interface.nicByTFE.id}"
    device_index         = 0
  }
}
#File =/vars.tf
variable "region" {
  type  = string
}

variable "ami" {
  type    = string
  default = "ami-6bcfc42e"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
