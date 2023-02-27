resource "aws_security_group" "wordpress-sg" {
  name        = "wordpress-sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.primary.id

  ingress {
    description = "wordpress access from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["209.214.68.250/32"]
  }

  ingress {
    description = "wordpress access from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["209.214.68.250/32"]
  }

  ingress {
    description = "wordpress access from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["209.214.68.250/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "wordpress-sg", Env = "dev" }
}