variable "name" {
  description = "MWAA environment for the apartment-finder project"
  default     = "apartment-finder-mwaa"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Default tags"
  default = {
    "project_name" : "apartment-finder"
  }
  type = map(string)
}

variable "vpc_cidr" {
  description = "VPC CIDR for MWAA"
  type        = string
  default     = "10.1.0.0/16"
}
