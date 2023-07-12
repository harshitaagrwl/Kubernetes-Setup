data "aws_ami" "myami" {
  most_recent = true
  owners      = [var.owner]
  filter {
    name   = "name"
    values = [var.ami_image_type]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}