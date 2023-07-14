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

    agent        = false
    bastion_host = aws_instance.bastionhost.public_ip
    bastion_user = "ec2-user" # or your desired username
  }




  provisioner "file" {
    source      = ("${path.module}/minikube_setup.yml")
    destination = "/home/ec2-user/minikube_setup.yml"

  }

  provisioner "file" {
    source      = ("${path.module}/app.yml")
    destination = "/home/ec2-user/app.yml"

  }

  provisioner "file" {
    source      = ("${path.module}/app-gateway.yml")
    destination = "/home/ec2-user/app-gateway.yml"

  }




  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install ansible2 -y",
      "ansible-playbook  minikube_setup.yml",
      "curl -L https://git.io/getLatestIstio | sh -",
      "export PATH=$PATH:/home/ec2-user/istio-1.18.0/bin",
      "istioctl install",
      "kubectl label namespace default istio-injection=enabled",
      "kubectl apply -f app.yaml",
      "kubectl apply -f app-gateway.yaml",
      "export INGRESS_HOST=$(minikube ip)",
      "export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=='http2')].nodePort}')"

    ]

  }
}

