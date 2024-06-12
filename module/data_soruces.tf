locals {
  current_year    = var.current_year
  region          = var.region
  first_subnet_id = element(data.aws_subnets.private.ids, 0)
  input_string    = aws_imagebuilder_image_pipeline.example.image_recipe_arn
  arnNewAmi       = replace(local.input_string, "-recipe", "")
}

data "aws_caller_identity" "current" {}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Tier = "Private"
  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}


data "aws_imagebuilder_component" "cloudwatch" {
  arn = "arn:aws:imagebuilder:${var.region}:aws:component/amazon-cloudwatch-agent-linux/x.x.x"
}

data "aws_imagebuilder_component" "awscli" {
  arn = "arn:aws:imagebuilder:${var.region}:aws:component/aws-cli-version-2-linux/x.x.x"
}

data "aws_imagebuilder_component" "kernel" {
  arn = "arn:aws:imagebuilder:${var.region}:aws:component/update-linux-kernel-mainline/x.x.x"
}

data "aws_imagebuilder_component" "update" {
  arn = "arn:aws:imagebuilder:${var.region}:aws:component/update-linux/x.x.x"
}