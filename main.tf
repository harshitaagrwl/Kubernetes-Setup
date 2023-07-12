module "ami" {
  source         = "./modules/ami"
  owner          = var.owner
  ami_image_type = var.ami_image_type
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = var.availability_zones
}

module "securitygroup" {
  source = "./modules/SecurityGroup"
  vpcid  = module.vpc.vpcid
  port   = var.port
}

module "keypair" {
  source   = "./modules/keypair"
  key_name = var.key_name
}

module "instance" {
  source             = "./modules/instance"
  ami_id             = module.ami.amiid
  instance_type      = var.instance_type
  public_subnet_id   = module.vpc.public_subnet
  private_subnet_id  = module.vpc.private_subnet
  sg_id              = module.securitygroup.sg_data
  key_name     = module.keypair.key_name
  availability_zones = var.availability_zones
  private_key        = module.keypair.privatekey
}


