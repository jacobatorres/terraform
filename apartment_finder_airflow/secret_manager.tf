resource "aws_secretsmanager_secret" "app_token" {
  name = "app_token"
}


resource "aws_secretsmanager_secret" "data_lacity_pw" {
  name = "data_lacity_pw"
}


resource "aws_secretsmanager_secret" "psql_pw" {
  name = "psql_pw"
}