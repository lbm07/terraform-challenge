# ─── Store a secret in SSM Parameter Store ───
resource "aws_ssm_parameter" "db_password" {
  name        = "/lab/database/password"
  description = "Database password for the lab application"
  type        = "SecureString"
  value       = "MySecureP@ssw0rd123"
  tags        = { Name = "Lab-DB-Password" }
}
# ─── Store the database host ───                          
resource "aws_ssm_parameter" "db_host" {
  name        = "/lab/database/host"
  description = "Database host"
  type        = "String"
  value       = "10.0.2.50"
  tags        = { Name = "Lab-DB-Host" }
}

# ─── IAM Role for EC2 ───
resource "aws_iam_role" "ec2_ssm" {
  name = "Lab-EC2-SSM-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}
# ─── Policy: Allow reading SSM parameters ───
resource "aws_iam_role_policy" "ssm_read" {
  name = "SSM-Read-Policy"
  role = aws_iam_role.ec2_ssm.id
  policy = jsonencode({ Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParametersByPath"
      ]
      Resource = "arn:aws:ssm:${var.aws_region}:*:parameter/lab/*"
    }]
  })
}
# ─── Instance Profile (connects IAM role to EC2) ───
resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "Lab-EC2-SSM-Profile"
  role = aws_iam_role.ec2_ssm.name
}