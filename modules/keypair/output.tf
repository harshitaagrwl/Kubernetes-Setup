output "privatekey" {
  value = tls_private_key.new_key.private_key_pem

}

output "key_name" {
  value = aws_key_pair.enter_key_name.key_name
}
