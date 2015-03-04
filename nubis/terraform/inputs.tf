variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "amis" {
    default = {
        us-east-1 = "ami-5c2e7634"
        us-west-2 = "ami-cd7754fd"
    }
}

variable "consul" {
  description = "URL to Consul."
  default = "127.0.0.1"
}

variable "consul_secret" {
  description = "Security shared secret for consul membership (consul keygen)."
}

variable "region" {
  description = "The region of AWS, for AMI lookups."
  default = "us-west-2"
}

variable "project" {
  description = "Name of the project"
  default = "mediawiki"
}

variable "environment" {
  description = "Environment the project is being deployed to."
  default = "sandbox"
}

variable "release" {
  description = "Release number of the architecture."
}

variable "build" {
  description = "Build number of the architecture."
}

variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
}

variable "key_file" {
  description = "SSH key file for remote-exec commands."
}

variable "dns_zone" {
    description = "The zone for which we are authoritative in which we create records"
    default = "nubis.allizom.org"
}