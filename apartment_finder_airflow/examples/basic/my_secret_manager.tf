resource "aws_secretsmanager_secret" "app_token" {
  name                    = "app_token_value"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "app_token" {
  secret_id     = aws_secretsmanager_secret.app_token.id
  secret_string = trim(var.app_token_password, "\"")
}


resource "aws_secretsmanager_secret" "data_lacity_pw" {
  name                    = "data_lacity_password_value"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "data_lacity_pw" {
  secret_id     = aws_secretsmanager_secret.data_lacity_pw.id
  secret_string = trim(var.data_lacity_password, "\"")
}

resource "aws_secretsmanager_secret" "psql_pw" {
  name                    = "psql_password_value"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "psql_pw" {
  secret_id     = aws_secretsmanager_secret.psql_pw.id
  secret_string = trim(var.db_password, "\"")
}
