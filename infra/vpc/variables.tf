variable "environment" {
    description = "Environment Name"
    type = string
}
variable "vpc_cidr" {
    description = "vpc cidr block name"
    type = string
}

variable "nat_gateway_count"{
    description = "number of nat gateways"
    type = string
}
variable "owner" {
    description = "Owner of the team"
    type = string
}
variable "team" {
    description = "which team the owner belongs to"
    type = string
}