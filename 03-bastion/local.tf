locals {
  public_subnet_ids = ["subnet-07183db75b09d73dc", "subnet-099c7e3976f118f45"]
  public_subnet_id  = local.public_subnet_ids[0]
}