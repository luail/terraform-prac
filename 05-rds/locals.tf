locals {
  vpc_id         = data.terraform_remote_state.eks.outputs.vpc_id
  public_subnets = data.terraform_remote_state.eks.outputs.public_subnets
}