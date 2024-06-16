resource "aws_db_instance" "default" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "nginxlogs"
  username               = "willedy"
  password               = "willedy-password"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.willedy.name

  tags = {
    Name = "${var.project_name}-rds-instance"
  }
}

resource "aws_db_subnet_group" "willedy" {
  name       = "willedy-subnet-group"
  subnet_ids = aws_subnet.willedy.*.id
  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}