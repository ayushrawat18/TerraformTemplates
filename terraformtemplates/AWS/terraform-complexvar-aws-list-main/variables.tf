
variable "access_key" {}
variable "secret_key" {}

variable "region" {
 type    = string
 default = "us-east-1"
}

variable "sampleTags" {
  default = ["Dev ebs volume with List", "Test ebs volume with List", "Prod ebs volume with List"]
  type = list(string)
}

variable "ebsSizes" {
  type = list(number)
  default = [40, 80, 120]
}
