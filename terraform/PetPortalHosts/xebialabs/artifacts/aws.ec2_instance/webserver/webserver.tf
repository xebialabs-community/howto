##########################################################################
#
# variables
variable "my-sg" {
  type = list(string)
}
variable "my-ami" {
  type = string
}
variable "ssh-key" {
  type    = string
}
variable "ami-size" {
  type         = string
}
##########################################################################
#  Webserver
#
resource "aws_instance" "webserver" {
  ami                    = var.my-ami
  instance_type          = var.ami-size
  key_name               = var.ssh-key
  vpc_security_group_ids = var.my-sg

  associate_public_ip_address = true
    tags = {
      Name = "rrb-webserver"
      Terraform   = "true"
      Environment = "dev"
    }

  user_data     = <<-EOF
                  #!/bin/bash
                  sudo yum -y install httpd
                  echo "<p> My Instance! </p>" >> /var/www/html/index.html
                  sudo systemctl enable httpd
                  sudo systemctl start httpd
                  EOF
}

#######################################################
#  Webserver Variables
output "public_ip" {
  description = "Public IP addresses of EC2 instances"
  value       = aws_instance.webserver.public_ip
}

output "private_ip" {
  description = "Private IP addresses of EC2 instances"
  value       = aws_instance.webserver.private_ip
}

output "public_dns" {
  description = "Public IP addresses of EC2 instances"
  value       = aws_instance.webserver.public_dns
}
output "private_dns" {
  description = "Private IP addresses of EC2 instances"
  value       = aws_instance.webserver.private_dns
}
