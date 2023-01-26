module "public_subnet_1st" {
  source = "./subnet"
  subnet_cidr_block = "10.0.0.0/24"
  sub_availability_zone = "us-east-1a"
  subnet_name = "public_subnet_1st"
  sub_vpc_id = module.lab3-vpc.vpc_id
}

module "public_subnet_2nd" {
  source = "./subnet"
  subnet_cidr_block = "10.0.2.0/24"
  sub_availability_zone = "us-east-1b"
  subnet_name = "public_subnet_2nd"
  sub_vpc_id = module.lab3-vpc.vpc_id
}

module "private_subnet_1st" {
  source = "./subnet"
  subnet_cidr_block = "10.0.1.0/24"
  sub_availability_zone = "us-east-1a"
  subnet_name = "private_subnet_1st"
  sub_vpc_id = module.lab3-vpc.vpc_id
}

module "private_subnet_2nd" {
  source = "./subnet"
  subnet_cidr_block = "10.0.3.0/24"
  sub_availability_zone = "us-east-1b"
  subnet_name = "private_subnet_2nd"
  sub_vpc_id = module.lab3-vpc.vpc_id
}
