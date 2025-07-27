module "vpc" {
 source = "git::https://github.com/chethan2010/terraform-vpc.git?ref=main"
# source = "../../Terraform/Terraform/variables.tf"
    project_name = var.Project_name
    common_tags = var.common_tags
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    database_subnet_cidrs = var.data_subnet_cidrs
    is_peering_required = var.is_peering_required
}
