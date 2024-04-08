data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.tfstate_bucket
    key    = var.tfstate_key
    region = var.region
  }
}
