module "backend_s3" {
  source = "./S3"
  bucket_name = "lab3-s3-terra-26-01-2023"
  bucket_versioning_configuration = "Enabled"
}

module "backend_dynamodb" {
  source = "./dynamoDB"
  table_name = "lab3-dynamoDB-terraform"
  table_hash_key = "ID"
  attribute_name = "ID"
  attribute_type = "S"
}

terraform {
  backend "s3"{
    bucket = "lab3-s3-terra-26-01-2023"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "lab3-dynamoDB-terraform"
    encrypt = true
  }
}