include "root" {
  path           = find_in_parent_folders()
  expose         = true
  merge_strategy = "deep"
}

terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc.git//.?ref=v3.14.2"
}

locals {
  azs = [
    "${include.root.locals.inputs.aws_region}a",
    "${include.root.locals.inputs.aws_region}b",
    "${include.root.locals.inputs.aws_region}c"
  ]
  cidr             = "100.100.0.0/16"
  subnets          = cidrsubnets(local.cidr, 3, 3, 3, 3, 3, 3, 3, 3)
  private_subnets  = chunklist(local.subnets, 3)[0]
  public_subnets   = chunklist(local.subnets, 3)[1]
  database_subnets = chunklist(local.subnets, 3)[2]
}

inputs = {

  tags = merge(
    include.root.locals.custom_tags
  )

  name = include.root.locals.inputs.application

  cidr = local.cidr

  azs              = local.azs
  private_subnets  = local.private_subnets
  public_subnets   = local.public_subnets
  database_subnets = local.database_subnets

  enable_ipv6                     = true
  assign_ipv6_address_on_creation = true
  public_subnet_ipv6_prefixes     = [0, 1, 2]
  private_subnet_ipv6_prefixes    = [3, 4, 5]
  database_subnet_ipv6_prefixes   = [6, 7]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${include.root.locals.inputs.application}" = "shared"
    "kubernetes.io/role/elb"                                          = "1"
    "Tier"                                                            = "public"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${include.root.locals.inputs.application}" = "shared"
    "kubernetes.io/role/internal-elb"                                 = "1"
    "Tier"                                                            = "private"
  }

  database_subnet_tags = {
    "kubernetes.io/cluster/${include.root.locals.inputs.application}" = "shared"
    "kubernetes.io/role/elb"                                          = "1"
    "Tier"                                                            = "db"
  }
}
