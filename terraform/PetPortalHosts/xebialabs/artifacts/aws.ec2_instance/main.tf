# Terraform configuration
provider "aws" {
  region = "{{aws_region}}"
  access_key = "{{AWS_ACCESS_KEY}}"
  secret_key = "{{AWS_SECRET_KEY}}"
}

##########################################################################
#  Webserver
#
module "webserver" {
    source = "./webserver"
    my-ami = var.ami
    my-sg = var.security_groups
    ami-size = var.ami-size
    ssh-key  = var.ssh-key
    project  = var.project
}
##########################################################################
#  Appserver
#
module "appserver" {
    source   = "./appserver"
    my-ami   = var.ami
    my-sg    = var.security_groups
    ami-size = var.ami-size
    ssh-key  = var.ssh-key
    project  = var.project
}

##########################################################################
#  RDS Database
#
module "db" {
    source = "./db"
    my-sg = var.security_groups
    project  = var.project
}
