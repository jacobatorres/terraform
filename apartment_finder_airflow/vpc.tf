//VPC

resource "aws_vpc" "tutorial_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = var.project_name
  }

}


// internet gateway

resource "aws_internet_gateway" "tutorial_igw" {

  vpc_id = aws_vpc.tutorial_vpc.id

  tags = {
    Name = var.project_name
  }

}



resource "aws_subnet" "tutorial_public_subnet" {
  count             = var.subnet_count.public
  vpc_id            = aws_vpc.tutorial_vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]


  tags = {
    Name = var.project_name
  }

}


resource "aws_subnet" "tutorial_private_subnet" {

  count             = var.subnet_count.private
  vpc_id            = aws_vpc.tutorial_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]


  tags = {
    Name = var.project_name
  }
}


resource "aws_route_table" "tutorial_public_rt" {
  vpc_id = aws_vpc.tutorial_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tutorial_igw.id
  }
}


resource "aws_route_table_association" "public" {

  count          = var.subnet_count.public
  route_table_id = aws_route_table.tutorial_public_rt.id
  subnet_id      = aws_subnet.tutorial_public_subnet[count.index].id

}




resource "aws_route_table" "tutorial_private_ip" {
  vpc_id = aws_vpc.tutorial_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tutorial_igw.id
  }

}


resource "aws_route_table_association" "private" {

  count          = var.subnet_count.private
  route_table_id = aws_route_table.tutorial_private_ip.id
  subnet_id      = aws_subnet.tutorial_private_subnet[count.index].id

}



resource "aws_security_group" "tutorial_web_sg" {

  name        = "tutorial_web_sg"
  description = "SG for web server"
  vpc_id      = aws_vpc.tutorial_vpc.id

  ingress {
    description = "allow all traffic thru http"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "allow ssh from my computer"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  egress {
    description = "allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.project_name
  }


}





resource "aws_security_group" "tutorial_db_sg" {

  name        = "tutorial_db_sg"
  description = "SG for the rds"

  vpc_id = aws_vpc.tutorial_vpc.id

  ingress {
    description     = "allow postgres traffic only from the web sg"
    from_port       = "5432"
    to_port         = "5432"
    protocol        = "tcp"
    security_groups = [aws_security_group.tutorial_web_sg.id]
  }


  ingress {
    description = "allow postgres traffic only from my ip"
    from_port   = "5432"
    to_port     = "5432"
    protocol    = "tcp"
    cidr_blocks = ["45.48.40.241/32"]
  }

  egress {
    description = "allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = var.project_name
  }

}



resource "aws_db_subnet_group" "tutorial_db_subnet_group" {
  name        = "tutorial_db_subnet_group"
  description = "db subnet group"
  subnet_ids  = [for subnet in aws_subnet.tutorial_private_subnet : subnet.id]
}

# variable "rds_ec2_settings" {
#   description = "Config settings"
#   type        = map(any)
#   default = {
#     "database" = {
#       allocated_storage   = 10 // 10GB
#       engine              = "postgresql"
#       engine_version      = "8.0.27"
#       instance_class      = "db.t2.micro"
#       db_name             = "tutorial"
#       skip_final_snapshot = true
#     },
#     "web_app" = {
#       count         = 1
#       instance_type = "t2.micro"
#     }
#   }
# }



// the DB instance!

resource "aws_db_instance" "tutorial_database" {

  allocated_storage      = 100
  engine                 = "postgres"
  engine_version         = "14.10"
  instance_class         = "db.t3.micro"
  db_name                = "tutorial"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.tutorial_db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.tutorial_db_sg.id]
  skip_final_snapshot    = true
  multi_az               = false

  publicly_accessible = true

}


// the ec2 instance!

// end for today! we ended at Creating the Key Pair

resource "aws_key_pair" "tutorial_kp" {
  key_name   = "tutorial_kp"
  public_key = file("tutorial_kp.pub")
}



# data "aws_ami" "ubuntu" {
#   most_recent = "true"

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"]
# }



# variable "rds_ec2_settings" {
#   description = "Config settings"
#   type        = map(any)
#   default = {
#     "database" = {
#       allocated_storage   = 10 // 10GB
#       engine              = "postgresql"
#       engine_version      = "8.0.27"
#       instance_class      = "db.t2.micro"
#       db_name             = "tutorial"
#       skip_final_snapshot = true
#     },
#     "web_app" = {
#       count         = 1
#       instance_type = "t2.micro"
#     }
#   }
# }





resource "aws_instance" "tutorial_web" {

  count = 1

  ami           = "ami-05d47d29a4c2d19e1"
  instance_type = "r6g.medium"

  subnet_id = aws_subnet.tutorial_public_subnet[count.index].id


  key_name = aws_key_pair.tutorial_kp.key_name

  vpc_security_group_ids = [aws_security_group.tutorial_web_sg.id]




  tags = {
    Name = var.project_name
  }

}




resource "aws_eip" "tutorial_web_eip" {
  count    = 1
  instance = aws_instance.tutorial_web[count.index].id
  vpc      = true


  tags = {
    Name = var.project_name
  }
}
















