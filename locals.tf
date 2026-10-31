locals {
  required_tags = {
    Owner       = var.owner
    CostCenter  = var.cost_center
    Environment = "dev"
  }
}
