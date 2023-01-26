module "lab3-vpc" {
  source = "./vpc"
  vpc_cider = "10.0.0.0/16"
  vpc_name = "lab3-vpc"
}

module "internet_gateway" {
  source = "./igw"
  igw_name = "my_internet_gateway"
  igw_vpc_id = module.lab3-vpc.vpc_id
}

module "nat_gateway" {
  source = "./nat gateway"
  nat_name = "lab3-gateway"
  nat_subnet_id = module.public_subnet_1st.lab3-subnet_id
  nat_depends_on = module.internet_gateway
}

module "security_group" {
  source = "./securitygroup"
  securitygroup_name = "security_group"
  securitygroup_description = "security_group"
  securitygroup_vpc_id = module.lab3-vpc.vpc_id
  securitygroup_from_port_in = 22
  securitygroup_to_port_in = 80
  securitygroup_protocol_in = "tcp"
  securitygroup_cider = ["0.0.0.0/0"]
  securitygroup_from_port_eg = 0
  securitygroup_to_port_eg = 0
  securitygroup_protocol_eg = "-1"
}


module "public_route_table" {
  source = "./routetable"
  table_name = "lab3-public_table"
  table_vpc_id = module.lab3-vpc.vpc_id
  table_destination_cidr_block = "0.0.0.0/0"
  table_gateway_id = module.internet_gateway.lab3-igw
  table_subnet_id = { id1 = module.public_subnet_2nd.lab3-subnet_id, id2 = module.public_subnet_1st.lab3-subnet_id }
  depends_on = [
    module.public_subnet_1st.subnet_id,
    module.private_subnet_2nd.subnet_id
  ]
}

module "lb_public" {
  source = "./loadbalncer"

  target_name = "public"
  target_port = "80"
  target_protocol = "HTTP"
  target_vpc_id = module.lab3-vpc.vpc_id

  attach_target_id = { id1 = module.ec2_public_01.ec2_id, id2 = module.ec2_public_02.ec2_id }
  attach_target_port = "80"

  lb_name = "public"
  lb_internal = false
  lb_type = "application"
  lb_security_group = [ module.security_group.securitygroup_id ]
  lb_subnet = [ module.public_subnet_1st, module.public_subnet_2nd ]

  listener_port = "80"
  listener_protocol = "HTTP"
  listener_type = "forward"

  depends_on = [
    module.lab3-vpc,
    module.ec2_public_01,
    module.ec2_public_02,
    module.public_subnet_1st,
    module.public_subnet_2nd
  ]

}

module "private_route_table" {
  source = "./routetable"
  table_name = "private_table"
  table_vpc_id = module.lab3-vpc.vpc_id
  table_destination_cidr_block = "0.0.0.0/0"
  table_gateway_id = module.nat_gateway.nat_gw_id
  table_subnet_id = {id1 = module.private_subnet_2nd.lab3-subnet_id, id2 = module.private_subnet_1st.lab3-subnet_id }
}

module "lb_private" {
  source = "./loadbalncer"

  target_name = "private"
  target_port = "80"
  target_protocol = "HTTP"
  target_vpc_id = module.lab3-vpc.vpc_id

  attach_target_id = { id1 = module.private_ec2_1st.ec2_id, id2 = module.private_ec2_2nd.ec2_id }
  attach_target_port = "80"

  lb_name = "private"
  lb_internal = true
  lb_type = "application"
  lb_security_group = [ module.security_group.securitygroup_id ]
  lb_subnet = [ module.private_subnet_1st, module.private_subnet_2nd ]

  listener_port = "80"
  listener_protocol = "HTTP"
  listener_type = "forward"

  depends_on = [
    module.lab3-vpc,
    module.private_ec2_1st,
    module.private_ec2_2nd,
    module.private_subnet_1st,
    module.private_subnet_2nd
  ]

}
