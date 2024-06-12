locals {
  region = "us-east-1"
}

variable "name" {
  type    = string
  default = "Amazon-linux-2"
}

variable "vpc" {
  type = string
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

# data "aws_iam_role" "profile" {
#   name = "EC2InstanceProfileForImageBuilder"
# }
