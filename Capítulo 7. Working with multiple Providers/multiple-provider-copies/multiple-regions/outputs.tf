output "region_1_name" {
    description = "The name of the first region"
    value = data.aws_region.region_1.name
}
output "region_2_name" {
    description = "The name of the second region"
    value = data.aws_region.region_2.name
}

output "instance_region_1_az" {
    value = aws_instance.region_1_instance.availability_zone
    description = "The Az where the instance is deployed"
}
output "instance_region_2_az" {
    value = aws_instance.region_2_instance.availability_zone
    description = "The Az where the instance is deployed"
}