variable "region" {
  description = "AWS region"
  type        = string
}

variable "owner" {
  description = "owner detail"
  type        = string
}

variable "ami_image_type" {
  description = "AMI Image type"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
  type        = string
}

variable "public_subnets_cidr" {
  type        = string
  description = "CIDR block for Public Subnet"
}

variable "private_subnets_cidr" {
  type        = string
  description = "CIDR block for Private Subnet"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "port" {
  description = "Port to be expose"
  type        = list(number)
}

variable "key_name" {
  description = "Key Name"
  type        = string
}

variable "instance_type" {
  description = "instance type"
  type        = string
}