locals {
  public_subnet_ids = ["subnet-01a1401925fbbfaa6","subnet-09fe69a8b7169be21"]
  public_subnet_id  = local.public_subnet_ids[0]
}