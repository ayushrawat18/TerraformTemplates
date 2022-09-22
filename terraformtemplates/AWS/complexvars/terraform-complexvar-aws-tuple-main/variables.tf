variable "access_key" {}
variable "secret_key" {}

variable "region" {
 type    = string
 default = "us-east-1"
}

variable "sampleTuple" {
  type    = tuple([number,string,string])
  default = [40, "Dev ebs volume using tuple", "Test ebs volume using tuple"]
}
