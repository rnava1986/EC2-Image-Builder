output "ami_id" {
  value = aws_imagebuilder_image_pipeline.example.arn
}

output "latest_ami_id" {
  value = aws_imagebuilder_image_pipeline.example.date_last_run
}

output "image_recipe_arn" {
  value = aws_imagebuilder_image_pipeline.example.image_recipe_arn
}