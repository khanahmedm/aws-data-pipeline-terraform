resource "aws_glue_catalog_database" "financial_db" {
  name = "financial_database"
}

resource "aws_glue_catalog_table" "financial_table" {
  name          = "transactions"
  database_name = aws_glue_catalog_database.financial_db.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    "classification" = "csv"
    "skip.header.line.count" = "1" # Skips the header row in CSV
  }

  storage_descriptor {
    location      = var.financial_raw_data_bucket_name
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "csv"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "separatorChar" = ","
        "quoteChar"     = "\""
      }
    }

    columns {
      name = "transaction_id"
      type = "string"
    }
    columns {
      name = "amount"
      type = "double"
    }
    columns {
      name = "transaction_date"
      type = "string"
    }
  }
}

