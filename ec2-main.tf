module "ec2_public_01" {
  source = "./ec2"
  ec2_ami_id = "ami-06878d265978313ca"
  ec2_instance_type = "t2.micro"
  ec2_name = "ec2-public-1"
  ec2_public_ip = true
  ec2_subnet_ip = module.public_subnet_1st.lab3-subnet_id
  ec2_security_gr = [ module.security_group.securitygroup_id ]
  ec2_key_name = "lab3-terraform"
  ec2_connection_type = "ssh"
  ec2_connection_user = "ubuntu"
  ec2_connection_private_key = "./lab3-terraform.pem"
  ec2_provisioner_file_source = "./nginx.sh"
  ec2_provisioner_file_destination = "/tmp/nginx.sh"
  ec2_provisioner_inline = [ "chmod 777 /tmp/nginx.sh", "/tmp/nginx.sh ${module.lb_private.lb_public_dns}" ]
  depends_on = [
    module.public_subnet_1st.subnet_id,
    module.public_route_table.route_table_id,
    module.lb_private.lb_public_dns
  ]
}

module "ec2_public_02" {
  source = "./ec2"
  ec2_ami_id = "ami-06878d265978313ca"
  ec2_instance_type = "t2.micro"
  ec2_name = "ec2-public-2"
  ec2_public_ip = true
  ec2_subnet_ip = module.public_subnet_2nd.lab3-subnet_id
  ec2_security_gr = [ module.security_group.securitygroup_id ]
  ec2_key_name = "lab3-terraform"
  ec2_connection_type = "ssh"
  ec2_connection_user = "ubuntu"
  ec2_connection_private_key = "./lab3-terraform.pem"
  ec2_provisioner_file_source = "./nginx.sh"
  ec2_provisioner_file_destination = "/tmp/nginx.sh"
  ec2_provisioner_inline = [ "chmod 777 /tmp/nginx.sh", "/tmp/nginx.sh ${module.lb_private.lb_public_dns}" ]
  depends_on = [
    module.public_subnet_2nd.subnet_id,
    module.public_route_table.route_table_id,
    module.lb_private.lb_public_dns
  ]
}

module "private_ec2_1st" {
  source = "./private ec2"
  ec2_ami_id = "ami-06878d265978313ca"
  ec2_instance_type = "t2.micro"
  ec2_name = "private-ec2-1"
  ec2_subnet_ip = module.private_subnet_1st.lab3-subnet_id
  ec2_security_gr = [ module.security_group.securitygroup_id ]
  ec2_key_name = "lab3-terraform"
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install nginx -y
    sudo systemctl start nginx
    sudo systemctl enable nginx
    sudo chmod 777 /var/www/html
    sudo chmod 777 /var/www/html/index.nginx-debian.html
    sudo echo "<h1>Hi This is Private EC2 02</h1>" > /var/www/html/index.nginx-debian.html
    sudo systemctl restart nginx
  EOF
}

module "private_ec2_2nd" {
  source = "./private ec2"
  ec2_ami_id = "ami-06878d265978313ca"
  ec2_instance_type = "t2.micro"
  ec2_name = "private-ec2-2"
  ec2_subnet_ip = module.private_subnet_2nd.lab3-subnet_id
  ec2_security_gr = [ module.security_group.securitygroup_id ]
  ec2_key_name = "lab3-terraform"
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install nginx -y
    sudo systemctl start nginx
    sudo systemctl enable nginx
    sudo chmod 777 /var/www/html
    sudo chmod 777 /var/www/html/index.nginx-debian.html
    sudo echo "<h1>Hi This is Private EC2 01</h1>" > /var/www/html/index.nginx-debian.html
    sudo systemctl restart nginx
  EOF
}



