
data "terraform_remote_state" "microservice" {
  backend = "s3"
  config = {
    bucket = var.tfstate_bucket
    key    = var.tfstate_microservice_key
    region = var.region
  }
}
