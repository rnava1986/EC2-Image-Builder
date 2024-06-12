#######################
## Variables locales ##
#######################
variable "name" {
  type = string
}

variable "versioning" {
  type = string
}

variable "current_year" {
  type = string
}

variable "image_id" {
  type = string
}

# variable "aws_iam_role" {
#   type = string

# }

variable "instance_type" {
  default = "t3a.micro"
}

variable "region" {

}

variable "tags" {
  default = {
    "CostCenter"            = "Production"
    Environment             = "Production"
    Area                    = "Sales"
  }
}

variable "vpc_id" {

}


variable "cloudwatch" {
  default = "arn:aws:imagebuilder:us-east-1:aws:component/amazon-cloudwatch-agent-linux/x.x.x"
}

variable "awscli" {
  default = "arn:aws:imagebuilder:us-east-1:aws:component/aws-cli-version-2-linux/x.x.x"
}

variable "kernel" {
  default = "arn:aws:imagebuilder:us-east-1:aws:component/update-linux-kernel-mainline/x.x.x"
}

variable "update" {
  default = "arn:aws:imagebuilder:us-east-1:aws:component/update-linux/x.x.x"
}
