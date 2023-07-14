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
  type        = list(string)
  description = "AZ in which all the resources will be deployed"
}
