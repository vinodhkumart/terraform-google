provider "aws" {
        access_key = "myaccesskey"
        secret_key = "mysecretkey"
        region = "us-west-2"
}


# Creating the Security Group !!

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Creating ec2 instance with
resource "aws_instance" "apache" {
        ami = "ami-00c03f7f7f2ec15c3"
        instance_type = "t2.micro"
        key_name = "vinod_keypair"
        availability_zone = "us-west-2a"
        security_groups = ["${aws_security_group.allow_all.name}"]
         tags = {
                 Name = "Telstra-testing"
          }
}

# Create a database server
resource "aws_db_instance" "default" {
  engine         = "mysql"
  engine_version = "5.6.37"
  instance_class = "db.t2.micro"
  name           = "initial_db"
  username       = "rootuser"
  password       = "rootpasswd"
  skip_final_snapshot = true
  allocated_storage = 5
  tags = {
    Name = "Telstramysqldb"
  }

  # etc, etc; see aws_db_instance docs for more
}

# Configure the MySQL provider based on the outcome of
# creating the aws_db_instance.
provider "mysql" {
  endpoint = "${aws_db_instance.default.endpoint}"
  username = "${aws_db_instance.default.username}"
  password = "${aws_db_instance.default.password}"
}
