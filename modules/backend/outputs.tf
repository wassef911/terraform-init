output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.ec2_instance.id
}
