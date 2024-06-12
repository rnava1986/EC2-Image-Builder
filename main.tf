module "ec2_builder_image_al2" {
  source       = "./module"
  name         = var.name
  versioning   = "v1"
  current_year = "2024"
  vpc_id       = var.vpc
  image_id     = data.aws_ami.amazon_linux_2.id
  region       = local.region
}

