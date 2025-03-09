data "aws_secretsmanager_secret" "financialdb_password" {
  name = "financialdb_password"
}

data "aws_secretsmanager_secret_version" "financialdb_password" {
  secret_id = data.aws_secretsmanager_secret.financialdb_password.id
}
