# Create Security Group for ec2
resource "aws_security_group" "allow-rule" {
  name        = "allow_rule"
  description = "Allow inbound traffic"

  vpc_id = var.vpcid

  dynamic "ingress" {
    for_each = var.port
    iterator = port_number
    content {

      description = "Allow Port ${port_number.value}"
      from_port   = port_number.value
      to_port     = port_number.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-terraform-sg"
  }
}
