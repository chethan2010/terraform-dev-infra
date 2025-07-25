variable "Project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
  
}
variable "public_subnet_cidrs" {
  default = ["10.0.11.0/24","10.0.12.0/24"]
}

variable "private_subnet_cidrs" {
    default = ["10.0.21.0/24","10.0.22.0/24"]
  
}

variable "data_subnet_cidrs" {
    default = ["10.0.31.0/24","10.0.32.0/24"]
  
}

variable "common_tags" {
    default = {

        Project="Expense"
        Environment="dev"
        terraform="true"
    }
  
}

variable "is_peering_required" {
    default = true
  