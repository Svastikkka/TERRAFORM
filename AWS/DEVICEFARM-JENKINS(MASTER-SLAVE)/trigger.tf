# create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name = "sk vpc"
    Cost = "SKDevOps"
  }
}
# create the gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "sk gateway"
    Cost = "SKDevOps"
  }
}
# create the subnet
resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnetCIDRblock
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone
  tags = {
     Name = "sk vpc subnet"
     Cost = "SKDevOps"
  }
}

# create the security group
resource "aws_security_group" "sg" {
  vpc_id      = aws_vpc.vpc.id
  # ... other configuration ...
  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "sk security group"
    Cost = "SKDevOps"
  }
}

# network_interface
resource "aws_network_interface" "network_interface1" {
  subnet_id = aws_subnet.subnet.id
  security_groups = [aws_security_group.sg.id]
  private_ip = "10.0.15.4"
  tags = {
     Name = "sk network interface"
     Cost = "SKDevOps"
  }
}
# network_interface
resource "aws_network_interface" "network_interface2" {
  subnet_id = aws_subnet.subnet.id
  security_groups = [aws_security_group.sg.id]
	private_ip = "10.0.15.47"
  tags = {
     Name = "sk network interface"
     Cost = "SKDevOps"
  }
}
# network_interface
resource "aws_network_interface" "network_interface3" {
  subnet_id = aws_subnet.subnet.id
  security_groups = [aws_security_group.sg.id]
	private_ip = "10.0.15.71"
  tags = {
     Name = "sk network interface"
     Cost = "SKDevOps"
  }
}
# network_interface
resource "aws_network_interface" "network_interface4" {
  subnet_id = aws_subnet.subnet.id
  security_groups = [aws_security_group.sg.id]
	private_ip = "10.0.2.112"
  tags = {
     Name = "sk network interface"
     Cost = "SKDevOps"
  }
}

# create the  ec2 
resource "aws_instance" "app_db" {
  ami           = var.app_db_ami
  instance_type = var.app_db_instance_type
  count         = var.app_db_count
  network_interface {
    network_interface_id = aws_network_interface.network_interface1.id
    device_index = 0
  }
  tags = {
    Name = "RTC-SK-APP-DB-SETUP-1"
    Cost = "SKDevOps"
  }
}

# create the  ec2 
resource "aws_instance" "desknow_roundcube" {
  ami           = var.desknow_roundcube_ami
  instance_type = var.desknow_roundcube_instance_type
  count         = var.desknow_roundcube_count
  network_interface {
    network_interface_id = aws_network_interface.network_interface2.id
    device_index = 0
  }
  tags = {
    Name  = "RTC-SK-MAILSERVER-SETUP-1"
     Cost = "SKDevOps"
  }
}

# create the  ec2 
resource "aws_instance" "slave" {
  ami           = var.slave_ami
  instance_type = var.slave_instance_type
  count         = var.slave_count
  network_interface {
    network_interface_id = aws_network_interface.network_interface3.id
    device_index = 0
  }
  tags = {
    Name = "RTC-SK-SLAVE-PUSH-SETUP-1"
    Cost = "SKDevOps"
  }
}

# create the  ec2 
resource "aws_instance" "master" {
  ami           = var.master_ami
  instance_type = var.master_instance_type
  count         = var.master_count
  network_interface {
    network_interface_id = aws_network_interface.network_interface4.id
    device_index = 0
  }
  tags = {
    Name = "RTC-SK-MASTER-SETUP-1"
    Cost = "SKDevOps"
  }
}
