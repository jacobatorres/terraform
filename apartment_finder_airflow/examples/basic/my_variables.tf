variable "aws_region" {
  default = "us-east-1"
}


variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}


variable "subnet_count" {
  description = "number of subnets"
  type        = map(number)
  default = {
    public  = 1,
    private = 2
  }
}


// configuration for the ec2 and rds instances

variable "rds_ec2_settings" {
  description = "Config settings"
  type        = map(any)
  default = {
    "database" = {
      allocated_storage   = 10 // 10GB
      engine              = "mysql"
      engine_version      = "8.0.27"
      instance_class      = "db.t2.micro"
      db_name             = "tutorial"
      skip_final_snapshot = true
    },
    "web_app" = {
      count         = 1
      instance_type = "t2.micro"
    }
  }
}


variable "public_subnet_cidr_blocks" {

  description = "Available CIDR blocks for public subnets"
  type        = list(string)
  default = [
    "10.1.1.0/24",
    "10.1.2.0/24",
    "10.1.3.0/24",
    "10.1.4.0/24",
  ]
}


variable "private_subnet_cidr_blocks" {

  description = "Available CIDR blocks for private subnets"
  type        = list(string)
  default = [
    "10.1.101.0/24",
    "10.1.102.0/24",
    "10.1.103.0/24",
    "10.1.104.0/24",

  ]
}



variable "my_ip" {
  description = "my ip address"
  type        = string
  sensitive   = true
}


variable "db_username" {
  description = "db master user"
  type        = string
  sensitive   = true
  default     = "none"
}


variable "db_password" {
  description = "the pw"
  type        = string
  sensitive   = true
  default     = "none"
}


variable "project_name" {
  type    = string
  default = "tutorial"
}


variable "app_token_password" {
  default = ""
}

variable "data_lacity_password" {
  default = ""
}











