module "vpc" {
source = "git::https://github.com/chethan2010/terraform-vpc.git?ref=main"
Project_Name =var.Project_Name
Common_tags = var.Common_tags
public_subnet_cidrs= var.public_subnet_cidrs
private_subnet_cidrs = var.private_subnet_cidrs
database_subnet_cidrs = var.database_subnet_cidrs
is_perring =var.is_peering_required
}

