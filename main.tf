resource "aws_instance" "apache-server" {
  ami                    = data.aws_ami.amazon-linux-2.id               # Define the AMI you want to use
  instance_type          = var.instance_type                            # Default instance type
  key_name               = var.key_name                                 # Define your SSH key name here
  count                  = var.instance_count                           # Define the number of instances you want to create
  vpc_security_group_ids = [aws_security_group.terraform_project_sg.id] # Define the security group you want to use  
  depends_on             = [aws_security_group.terraform_project_sg]    # Wait for the security group to be created before creating the instance
  user_data              = file("create_apache.sh")                     # Define the user data script to be executed on the instance

  tags = {
    "Name" = "Terraform ${element(var.tag_name, count.index)} Instance" # Define the name of the instances you want to create and tag with count.index
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public_ip.txt" # Write the public IP of the instances to a file
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ip.txt" # Write the private IP of the instances to a file
  }
}
