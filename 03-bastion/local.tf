locals {
  public_subnet_ids = ["subnet-0caa85dd0cf433b63", "subnet-0774bf65db82ef4bd"]
  public_subnet_id  = local.public_subnet_ids[0]
}