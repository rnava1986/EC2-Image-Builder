output "ami_id" {
  value = module.ec2_builder_image_al2.ami_id
}

output "latest_ami_id" {
  value = module.ec2_builder_image_al2.latest_ami_id
}

output "image_recipe_arn" {
  value = module.ec2_builder_image_al2.image_recipe_arn
}
