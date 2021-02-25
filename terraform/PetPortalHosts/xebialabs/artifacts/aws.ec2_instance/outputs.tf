# Output variable definitions
#######################################################
#  Webserver Variables
output "webserver_public_ip" {
  description = "Public IP addresses of EC2 instances"
  value       = module.webserver.public_ip
}

output "webserver_private_ip" {
  description = "Private IP addresses of EC2 instances"
  value       = module.webserver.private_ip
}

output "webserver_public_dns" {
  description = "Public IP addresses of EC2 instances"
  value       = module.webserver.public_dns
}
output "webserver_private_dns" {
  description = "Private IP addresses of EC2 instances"
  value       = module.webserver.private_dns
}
output "APACHE_HOST" {
  description = "Private IP addresses of EC2 instances"
  value       = module.webserver.private_ip
}
#######################################################
#  Appserver Variables
output "appserver_public_ip" {
  description = "Public IP addresses of EC2 instances"
  value       = module.appserver.public_ip
}

output "appserver_private_ip" {
  description = "Private IP addresses of EC2 instances"
  value       = module.appserver.private_ip
}

output "appserver_public_dns" {
  description = "Public IP addresses of EC2 instances"
  value       = module.appserver.public_dns
}

output "appserver_private_dns" {
  description = "Private IP addresses of EC2 instances"
  value       = module.appserver.private_dns
}

output "APPSERVER_HOST" {
  description = "Private IP addresses of EC2 instances"
  value       = module.appserver.private_ip
}

#######################################################
#  MySQL Variables
output "db_endpoint" {
  description = "Public IP addresses of MySQL instances"
  value       = module.db.db_endpoint
}
output "db_address" {
  description = "Public IP addresses of MySQL instances"
  value       = module.db.db_address
}
output "db_port" {
  description = "Public IP addresses of MySQL instances"
  value       = module.db.db_port
}
output "DB_URL" {
  description = "JDBC URL"
  value = module.db.DB_URL
}
output "mysqlHostOption" {
  description = "mysql host option"
  value = module.db.mysqlHostOption
}
#######################################################

output "project" {
  value       = var.project
}
output "DB_USERNAME" {
  value       = "{{DB_USERNAME}}"
}
output "PETPORTAL_TITLE" {
  value       = "Pet Portal AWS Demo"
}
output "APPSERVER_PORT" {
  value      = "8080"
}
output "PETCLINIC_CONTEXT_ROOT" {
  value       = "petclinic"
}
output "APACHE_PORT" {
  value      = "80"
}
output "DB_DRIVER" {
  value      = "mysqlDriver_com.mysql.jdbc.Driver_5_1"
}
output "DB_PASSWORD" {
  value      = "{{DB_PASSWORD}}"
}
