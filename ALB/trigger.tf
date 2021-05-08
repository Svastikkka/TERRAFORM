# create region
provider "aws" {
  region = var.region
}

# create the VPC
resource "aws_vpc" "MyVPC" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name = "My VPC"
  }
}

# create the gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.MyVPC.id
  tags = {
    Name = "GateWay"
  }
}

# create the Subnet
resource "aws_subnet" "My_VPC_Subnet1" {
  vpc_id                  = aws_vpc.MyVPC.id
  cidr_block              = var.subnetCIDRblock1
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone1
  tags = {
     Name = "My VPC Subnet"
  }
} 

# create the Subnet
resource "aws_subnet" "My_VPC_Subnet2" {
  vpc_id                  = aws_vpc.MyVPC.id
  cidr_block              = var.subnetCIDRblock2
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone2
  tags = {
     Name = "My VPC Subnet"
  }
} 

# create the Subnet
resource "aws_subnet" "My_VPC_Subnet3" {
  vpc_id                  = aws_vpc.MyVPC.id
  cidr_block              = var.subnetCIDRblock3
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone1
  tags = {
     Name = "My VPC Subnet"
  }
}

resource "aws_network_interface" "app1" {
  subnet_id = aws_subnet.My_VPC_Subnet1.id
}

resource "aws_network_interface" "db" {
  subnet_id = aws_subnet.My_VPC_Subnet2.id
}

# create the ubuntu ec2 
resource "aws_instance" "EC2_1" {
  ami           = "ami-00399ec92321828f5"
  instance_type = "t2.micro"
  count         = "1"
  network_interface {
    network_interface_id = aws_network_interface.app1.id
    device_index = 0
  }

  tags = {
    Name = "My Ubuntu Ec2"
  }
}

# create the  windows ec2
resource "aws_instance" "EC2_2" {
  ami           = "ami-0b697c4ae566cad55"
  instance_type = "t2.micro"
  count         = "1"
  network_interface {
    network_interface_id = aws_network_interface.db.id
    device_index = 0
  }
  tags = {
    Name = "My Windows Ec2"
  }
}

# create the security group
resource "aws_security_group" "SecurityGroup1" {

  vpc_id      = aws_vpc.MyVPC.id
  # ... other configuration ...
  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
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
    Name = "My Security Group"
  }
}
# create the security group
resource "aws_security_group" "SecurityGroup2" {
  vpc_id      = aws_vpc.MyVPC.id
  # ... other configuration ...
  ingress {
    description      = "TLS from VPC"
    from_port        = 1443
    to_port          = 1443
    protocol         = "tcp"
    cidr_blocks      = ["10.0.1.0/24"]
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
    Name = "My Security Group"
  }
}
# create the security group
resource "aws_security_group" "SecurityGroup3" {
  vpc_id      = aws_vpc.MyVPC.id
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
    Name = "My Security Group"
  }
} 

resource "aws_lb" "Application_Load_Balancer" {
   name = "test-lb-terraform"
   internal = false
   load_balancer_type = "application"
   security_groups = [aws_security_group.SecurityGroup1.id]
   subnets = [aws_subnet.My_VPC_Subnet1.id, aws_subnet.My_VPC_Subnet2.id]
   enable_deletion_protection = true
  tags = {
   Environment = "ALB"
  }
}