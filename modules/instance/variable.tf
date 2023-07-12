
variable "instance_type" {
  description = "instance type"
  type        = string
}


variable "sg_id" {
  description = "SG ID"
}

variable "ami_id" {
  description = "AMI  ID"
  type        = string
}

variable "public_subnet_id" {
  description = "Subnet  ID"
  type        = string
}

variable "private_subnet_id" {
  description = "Subnet  ID"
  type        = string
}


variable "key_name" {
  description = "key name"
  type        = string
}

variable "availability_zones" {
  type        = list(string)
  description = "AZ in which all the resources will be deployed"
}

variable "private_key" {
  description = "key"
  type        = string
}