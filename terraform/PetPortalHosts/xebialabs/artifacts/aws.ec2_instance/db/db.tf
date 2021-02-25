##########################################################################
#
# variables
variable "my-sg" {
  type = list(string)
}

##########################################################################
#  RDS Database
#
resource "aws_db_instance" "mysqldb" {
  allocated_storage      = 100
  engine                 = "mysql"
  engine_version         = "5.7.19"
  identifier             = "rrb-mysqldb"
  instance_class         = "db.t2.micro"
  password               = "{{DB_USERNAME}}"
  skip_final_snapshot    = true
  storage_encrypted      = false
  username               = "{{DB_PASSWORD}}"
  vpc_security_group_ids = var.my-sg
}

#######################################################
#  MySQL Variables
output "db_endpoint" {
  description = "Public IP addresses of MySQL instances"
  value       = aws_db_instance.mysqldb.endpoint
}
output "db_address" {
  description = "Public IP addresses of MySQL instances"
  value       = aws_db_instance.mysqldb.address
}
output "db_port" {
  description = "Public IP addresses of MySQL instances"
  value       = aws_db_instance.mysqldb.port
}
output "DB_URL" {
  description = "JDBC URL"
  value = "jdbc:mysql://${aws_db_instance.mysqldb.endpoint}/mysql?verifyServerCertificate=falses&useSSL=true&requireSSL=true"
}
output "mysqlHostOption" {
  description = "mysql host option"
  value = "--host=${aws_db_instance.mysqldb.address}"
}
