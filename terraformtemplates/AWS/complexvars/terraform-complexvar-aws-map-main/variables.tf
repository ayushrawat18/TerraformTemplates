
variable "access_key" {}
variable "secret_key" {}

variable "region" {
 type    = string
 default = "us-east-1"
}


variable "sampleMap" {
  type = map(string)
  default = {
    size : "40"
    tag = "Dev ebs volume", 
  }
}
