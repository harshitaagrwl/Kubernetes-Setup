output "vpcid" {
  value = aws_vpc.myvpc.id
}

output "public_subnet" {
  value = aws_subnet.subnet-public.id
}

output "private_subnet" {
  value = aws_subnet.subnet-private.id
}