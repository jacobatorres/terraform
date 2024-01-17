resource "aws_secretsmanager_secret" "app_token" {
  name = "app_token_val_official"
}


resource "aws_secretsmanager_secret" "data_lacity_pw" {
  name = "data_lacity_password_official"
}


resource "aws_secretsmanager_secret" "psql_pw" {
  name = "psql_password_official"
}
