terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7.0"
    }
  }
}

provider "aws" {
  region = local.region
}

# -----------------------------------------------------------------------------
# key = PROVEEDOR + CUENTA + NOMBRE DE LA INFRA + AMBIENTE + NOMBRE DEL TFSTATE
# -----------------------------------------------------------------------------

# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-all-infraestructure"
#     region         = "us-east-1"
#     key            = "aws/045837062796/Delivery/EC2BuilderImage/PRD/terraform.tfstate"
#     dynamodb_table = "terraform-state-all-infraestructure"
#     encrypt        = true
#   }
# }
