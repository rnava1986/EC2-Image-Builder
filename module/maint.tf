
resource "aws_imagebuilder_image_pipeline" "example" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.example.arn
  enhanced_image_metadata_enabled  = true
  image_recipe_arn                 = aws_imagebuilder_image_recipe.example.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.example.arn
  name                             = "${var.name}-${var.versioning}"
  status                           = "ENABLED"
  tags                             = var.tags
  image_tests_configuration {
    image_tests_enabled = true
    timeout_minutes     = 720
  }
}

resource "aws_imagebuilder_distribution_configuration" "example" {
  name = "${var.name}-${var.versioning}"
  tags = var.tags

  distribution {
    license_configuration_arns = []
    region                     = var.region

    ami_distribution_configuration {
    }
  }
}

resource "aws_imagebuilder_image_recipe" "example" {
  name              = "${var.name}-${local.current_year}-${var.versioning}"
  parent_image      = var.image_id
  tags              = var.tags
  version           = "3.0.0"
  working_directory = "/tmp"

  block_device_mapping {
    device_name = "/dev/xvda"
    no_device   = false

    ebs {
      delete_on_termination = "true"
      encrypted             = "false"
      volume_size           = 8
      volume_type           = "gp3"
    }
  }

  component {
    component_arn = "arn:aws:imagebuilder:${var.region}:aws:component/amazon-cloudwatch-agent-linux/x.x.x"
  }
  component {
    component_arn = "arn:aws:imagebuilder:${var.region}:aws:component/aws-cli-version-2-linux/x.x.x"
  }
  component {
    component_arn = "arn:aws:imagebuilder:${var.region}:aws:component/update-linux-kernel-mainline/x.x.x"
  }
  component {
    component_arn = "arn:aws:imagebuilder:${var.region}:aws:component/update-linux/x.x.x"
  }

  systems_manager_agent {
    uninstall_after_build = false
  }
}

resource "aws_imagebuilder_infrastructure_configuration" "example" {
  
  instance_profile_name = aws_iam_role.example.arn
  instance_types = [
    var.instance_type,
  ]
  name          = "${var.name}-${var.versioning}"
  resource_tags = var.tags
  security_group_ids = [
    aws_security_group.allow_ssm.id,
  ]
  subnet_id                     = local.first_subnet_id
  tags                          = var.tags
  terminate_instance_on_failure = true

  instance_metadata_options {
    http_put_response_hop_limit = 1
    http_tokens                 = "optional"
  }
}


######################
## IAM Role for EC2 ##
######################
resource "aws_iam_role" "example" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  force_detach_policies = false
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder",
    "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds",
  ]
  max_session_duration = 3600
  name                 = "EC2InstanceProfileForImageBuilder"
  path                 = "/"
  tags                 = var.tags
}

############################
## Private Security Group ##
############################
resource "aws_security_group" "allow_ssm" {
  name        = "${var.name}-${var.versioning}-GOLDENAMI-TMP"
  description = "Allow TLS outbound traffic for SSM GOLDENAMI"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSM from VPC"
  }

  tags = merge(
    var.tags,
    {
      "Name"    = "${var.name}-${var.versioning}-GOLDENAMI-TMP"
      "Creator" = "${data.aws_caller_identity.current.user_id}"
    }
  )
}

