resource "random_password" "root_password" {
  length           = 20
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_special = "!#*()-_=+[]{}<>:?"
}


resource "aws_secretsmanager_secret" "root_secrets" {
  name                    = "root-password"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "db_secrets" {
  name                    = "db-password"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "root_secrets" {
  secret_id     = aws_secretsmanager_secret.root_secrets.id
  secret_string = random_password.root_password.result
}

resource "aws_secretsmanager_secret_version" "old_secrets" {
  secret_id     = aws_secretsmanager_secret.db_secrets.id
  secret_string = random_password.db_password.result
}