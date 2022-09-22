variable "access_key" {}
variable "secret_key" {}

variable "region" {
 type    = string
 default = "us-east-1"
}

variable "sampleObject" {
  type    = object({size=number, tag=string, isDev=bool})
  default = {
    size  : 40
    tag   = "Dev ebs volume", 
    isDev = true
  }
}
