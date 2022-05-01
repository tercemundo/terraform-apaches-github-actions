output "public_ip_0" { # Define the output variable to see the public IP of the instances
  value = "http://${aws_instance.apache-server[0].public_ip}"
}

output "public_ip_1" { # Define the output variable to see the public IP of the instances
  value = "http://${aws_instance.apache-server[1].public_ip}"
}

output "public_ips" {
  value = aws_instance.apache-server[*].public_ip
}
