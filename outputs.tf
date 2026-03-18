# ═══════════════════════════════════════════════════════════════════════════════
# Required Outputs for Lab 007
# ═══════════════════════════════════════════════════════════════════════════════

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "external_alb_dns_name" {
  description = "DNS name of the External Application Load Balancer"
  value       = aws_lb.external.dns_name
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "ssm_parameter_db_password_path" {
  description = "SSM path for the database password (SecureString)"
  value       = aws_ssm_parameter.db_password.name
}

output "ssm_parameter_db_host_path" {
  description = "SSM path for the database host (String)"
  value       = aws_ssm_parameter.db_host.name
}

# ═══════════════════════════════════════════════════════════════════════════════
# Additional Helpful Outputs
# ═══════════════════════════════════════════════════════════════════════════════

output "internal_alb_dns_name" {
  description = "DNS name of the Internal ALB (BONUS)"
  value       = aws_lb.internal.dns_name
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "web_asg_name" {
  description = "Name of the Web tier Auto Scaling Group"
  value       = aws_autoscaling_group.web.name
}

output "backend_asg_name" {
  description = "Name of the Backend tier Auto Scaling Group"
  value       = aws_autoscaling_group.backend.name
}
