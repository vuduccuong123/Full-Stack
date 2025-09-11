terraform {
  backend "s3" {
    bucket         = "cuongvd18-terraform-state"
    key            = "terraform.tfstate"   # tên file state
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true

    workspace_key_prefix = "infra"         # tự động thêm prefix theo workspace
  }
}