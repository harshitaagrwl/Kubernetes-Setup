resource "aws_instance" "bastionhost" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  availability_zone      = var.availability_zones[0]
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.sg_id]
  key_name               = var.key_name

  tags = {
    Name = "Bastion instance"
  }
}


resource "aws_instance" "minikube_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.sg_id]
  key_name               = var.key_name
  availability_zone      = var.availability_zones[1]
  tags = {
    Name : "Minikube Instance"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = var.private_key
    host        = self.private_ip

       agent       = false
      bastion_host = aws_instance.bastionhost.public_ip
      bastion_user = "ec2-user"  # or your desired username
  }




  provisioner "file" {
    source      = ("${path.module}/minikube_setup.yml")
    destination = "/home/ec2-user/minikube_setup.yml"

  }

  provisioner "file" {
    source      = ("${path.module}/pod.yml")
    destination = "/home/ec2-user/pod.yml"

  }




  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install ansible2 -y",
      "ansible-playbook  minikube_setup.yml"
    ]

  }
}

