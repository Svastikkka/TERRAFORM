# create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name = "sai vpc"
  }
}

# create the gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "sai gateway"
  }
}

# create the subnet
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnetCIDRblock1
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone1
  tags = {
     Name = "sai vpc subnet"
  }
} 

# create the subnet
resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnetCIDRblock2
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone2
  tags = {
     Name = "sai vpc subnet"
  }
}

resource "aws_network_interface" "app" {
  subnet_id = aws_subnet.subnet1.id
  security_groups = [aws_security_group.SecurityGroup3.id]
  tags = {
     Name = "sai app"
  }
}

resource "aws_network_interface" "db" {
  subnet_id = aws_subnet.subnet2.id
  security_groups = [aws_security_group.SecurityGroup2.id]
  tags = {
     Name = "sai db"
  }
}

# create the ubuntu ec2 
resource "aws_instance" "ubuntu" {
  ami           = lookup(var.ami, "${var.region}-ubuntu")
  instance_type = var.instance_type["micro"]
  count         = var.app_instance_count
  network_interface {
    network_interface_id = aws_network_interface.app.id
    device_index = 0
  }
  root_block_device {
      volume_size = var.app_root_volume_size
      volume_type = var.app_root_volume_type
      delete_on_termination = true
  }
  tags = {
    Name = "sai ubuntu ec2"
  }
}
resource "aws_ebs_volume" "app_ebs_volume" {
  count             = "${var.app_instance_count * length(var.app_ec2_device_names)}"
  availability_zone = "${element(aws_instance.ubuntu.*.availability_zone, count.index)}"
  size              = var.app_ebs_volume_size
  type              = var.app_ebs_volume_type
}
resource "aws_volume_attachment" "app_volume_attachement" {
  count       = "${var.app_instance_count * length(var.app_ec2_device_names)}"
  volume_id   = "${aws_ebs_volume.app_ebs_volume.*.id[count.index]}"
  device_name = "${element(var.app_ec2_device_names, count.index)}"
  instance_id = "${element(aws_instance.ubuntu.*.id, count.index)}"
}

# create the  windows ec2
resource "aws_instance" "windows" {
  ami           = lookup(var.ami, "${var.region}-windows")
  instance_type = var.instance_type["micro"]
  count         = var.db_instance_count
  network_interface {
    network_interface_id = aws_network_interface.db.id
    device_index = 0
  }
  root_block_device {
      volume_size = var.db_root_volume_size
      volume_type = var.db_root_volume_type
      delete_on_termination = true
  }
  tags = {
    Name = "sai windows ec2"
  }
}
resource "aws_ebs_volume" "db_ebs_volume" {
  count             = "${var.db_instance_count * length(var.db_ec2_device_names)}"
  availability_zone = "${element(aws_instance.windows.*.availability_zone, count.index)}"
  size              = var.db_ebs_volume_size
  type              = var.db_ebs_volume_type
}
resource "aws_volume_attachment" "db_volume_attachement" {
  count       = "${var.db_instance_count * length(var.db_ec2_device_names)}"
  volume_id   = "${aws_ebs_volume.db_ebs_volume.*.id[count.index]}"
  device_name = "${element(var.db_ec2_device_names, count.index)}"
  instance_id = "${element(aws_instance.windows.*.id, count.index)}"
}

# create the security group
resource "aws_security_group" "SecurityGroup1" {

  vpc_id      = aws_vpc.vpc.id
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
    Name = "sai security group"
  }
}
# create the security group
resource "aws_security_group" "SecurityGroup2" {
  vpc_id      = aws_vpc.vpc.id
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
    Name = "sai security group"
  }
}
# create the security group
resource "aws_security_group" "SecurityGroup3" {
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
    Name = "sai security group"
  }
} 

# application load balancer
resource "aws_lb" "Application_Load_Balancer" {
   name = "alb-terraform"
   internal = false
   load_balancer_type = "application"
   security_groups = [aws_security_group.SecurityGroup1.id]
   subnets = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
   enable_deletion_protection = false
  tags = {
   Environment = "ALB"
  }
}

# alb_target_group (instance target group)
resource "aws_lb_target_group" "alb_target_group" {
  name     = "alb-target-group"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.vpc.id
}



# alb_listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.Application_Load_Balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:iam::406059358747:server-certificate/TESTING"

  default_action {
    type            = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}