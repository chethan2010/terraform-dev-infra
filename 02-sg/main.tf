module "db"{
  source ="../../terraform-aws-securityGroups"
  project_name =var.project_name
  environment = var.environment
  sg_description = var.db_sg_description
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name ="db"
}


module "backend" {
  source = "../../terraform-aws-securityGroups"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Backend Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "backend"   
}

module "app_alb" {
  source = "../../terraform-aws-securityGroups"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for APP ALB Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "app_alb"
}

module "frontend" {
  source = "../../terraform-aws-securityGroups"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Frontend Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "frontend"
}

module "jenkins_sg_ids" {
  source = "../../terraform-aws-securityGroups"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Frontend Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "jenkins"
}

module "web_alb" {
  source = "../../terraform-aws-securityGroups"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Web ALB Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "web-alb"
}

module "bastion" {
  source = "../../terraform-aws-securityGroups"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Bastion Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "bastion"
}

module "vpn" {
  source ="../../terraform-aws-securityGroups"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for VPN Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "vpn"
  ingress_rules = var.vpn_sg_rules
}



# DB is accepting connections from backend
resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id # source is where you are getting traffic from
  security_group_id = module.db.sg_id
}


resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "db_vpn" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb.sg_id # source is where you are getting traffic from
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
  security_group_id = module.app_alb.sg_id
}

resource "aws_security_group_rule" "app_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from
  security_group_id = module.app_alb.sg_id
}

resource "aws_security_group_rule" "app_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id # source is where you are getting traffic from
  security_group_id = module.app_alb.sg_id
}

resource "aws_security_group_rule" "frontend_web_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb.sg_id 
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source is where you are getting traffic from
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "web_alb_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}

resource "aws_security_group_rule" "web_alb_public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}

resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

#added as part of Jenkins CICD
resource "aws_security_group_rule" "backend_default_vpc" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["172.31.0.0/16"]
  security_group_id = module.backend.sg_id
}

#added as part of Jenkins CICDresource "aws_security_group_rule" "ssh_jenkins-cicd" {
# resource "aws_security_group_rule" "ssh_jenkins-cicd" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.jenkins_sg_ids.sg_id  
# }

# resource "aws_security_group_rule" "jenkins_default_vpc" {
#   type              = "ingress"
#   from_port         = 8080
#   to_port           = 8080
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.jenkins_sg_ids.sg_id  
# }
# not required, we can connect from VPN
# resource "aws_security_group_rule" "frontend_public" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = module.frontend.sg_id
# }