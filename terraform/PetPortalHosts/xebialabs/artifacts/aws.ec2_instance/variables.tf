# Input variable definitions
variable "project" {
  description = "Project Name"
  type        = string
  default     = "ProjectName"
}

variable "ami" {
  description  = "AMI to use for servers"
  type         = string
  default      = "ami-0e01ce4ee18447327"
}

variable "ami-size" {
  description  = "AMI size"
  type         = string
  default      = "t2.micro"
}

variable "aws_region" {
  description  = "AWS Region"
  type         = string
  default      = "us-east-2"
}

variable "ssh-key" {
  type         = string
  default      = "rbroker-us1"
}
