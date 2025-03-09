resource "null_resource" "init_database" {
  depends_on = [aws_db_instance.financial_db]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
      Write-Host "Waiting for 3 minutes to ensure RDS is ready..."
      Start-Sleep -Seconds 180
      
      # Retrieve password from AWS Secrets Manager
      $pg_password = (aws secretsmanager get-secret-value --secret-id financialdb_password --query SecretString --output text)

      # Set environment variable for psql
      $Env:PGPASSWORD = $pg_password

      psql -h ${aws_db_instance.financial_db.address} -U postgres -d postgres -c "CREATE DATABASE financialdb;"
      psql -h ${aws_db_instance.financial_db.address} -U postgres -d financialdb -f .\modules\rds\ddl_transactions.sql
      psql -h ${aws_db_instance.financial_db.address} -U postgres -d financialdb -f .\modules\rds\dml_insert_transactions.sql
    EOT
  }
}
