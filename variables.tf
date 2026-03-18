# ─── AWS Region ───
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# ─── VPC CIDR (NOT 10.0.0.0/16 as required by lab) ───
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.16.0.0/16"
}

# ─── Public Subnets ───
variable "public_subnet_cidr_1" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "172.16.1.0/24"
}

variable "public_subnet_cidr_2" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "172.16.2.0/24"
}

# ─── Private Subnets ───
variable "private_subnet_cidr_1" {
  description = "CIDR block for private subnet 1"
  type        = string
  default     = "172.16.10.0/24"
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for private subnet 2"
  type        = string
  default     = "172.16.11.0/24"
}

# ─── Instance Configuration ───
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

# ─── Student Display Name ───
variable "student_name" {
  description = "Full name shown on web pages"
  type        = string
  default     = "Laila Monzer"
}
