module "basion" {
  source             = "./modules"
  project            = var.project
  environment        = var.environment
  region             = var.region
  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  subnet_public_ids  = data.terraform_remote_state.network.outputs.subnet_public_ids
  subnet_private_ids = data.terraform_remote_state.network.outputs.subnet_private_ids
  public_key_path    = var.public_key_path
}