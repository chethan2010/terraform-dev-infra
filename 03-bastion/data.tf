data "aws_ssm_parameter" "bastion_sg_id" {
  name = "/${var.project_name}/${var.environment}/bastion_sg_id"
}

# data "aws_ssm_parameter" "public_subnet_ids" {
#   name = "/${var.project_name}/${var.environment}/public_subnet_ids"
# }

resource "aws_ssm_parameter" "public_subnet_ids" {
  name        = "/expense/dev/public_subnet_ids"
  type        = "StringList"
  value       = local.public_subnet_id
  # join(",", module.vpc.public_subnet_ids) # or hardcoded list.
#   overwrite   = true  # Deprecated, so remove if you're using new AWS provider
 }

data "aws_ami" "ami_info" {

    most_recent = true
    owners = ["973714476881"]

    filter {
        name   = "name"
        values = ["RHEL-9-DevOps-Practice"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}