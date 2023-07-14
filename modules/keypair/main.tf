resource "tls_private_key" "new_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.new_key.private_key_pem
  filename        = "terraform-key-pair.pem"
  file_permission = 700
}

resource "aws_key_pair" "enter_key_name" {
  key_name   = var.key_name
  public_key = tls_private_key.new_key.public_key_openssh
}

