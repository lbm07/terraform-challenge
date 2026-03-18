# ─── Bastion Security Group ───
resource "aws_security_group" "bastion" {
  name        = "Bastion-SG"
  description = "Allow SSH from anywhere"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "Bastion-SG" }
}

# ─── ALB Security Group ───
resource "aws_security_group" "alb" {
  name        = "ALB-SG"
  description = "Allow HTTP from internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "ALB-SG" }
}

# ─── Web Server Security Group ───
resource "aws_security_group" "web" {
  name        = "Web-SG"
  description = "Allow HTTP from ALB, SSH from bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "Web-SG" }
}

# ─── Backend Security Group ───
resource "aws_security_group" "backend" {
  name        = "Backend-SG"
  description = "Allow port 3000 from Internal ALB, SSH from Bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "Backend-SG" }
}

# ─── Backend SG rule for Internal ALB (avoids circular dependency) ───
resource "aws_security_group_rule" "backend_from_internal_alb" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.backend.id
  source_security_group_id = aws_security_group.internal_alb.id
  description              = "API port from Internal ALB"
}

# ─── Internal ALB Security Group ───
resource "aws_security_group" "internal_alb" {
  name        = "Internal-ALB-SG"
  description = "Allow traffic from Web tier to internal ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from Web tier"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "Internal-ALB-SG" }
}
