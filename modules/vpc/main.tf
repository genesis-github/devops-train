# Create VPC/Subnet/Security Group/Network ACL


# create the VPC
resource "aws_vpc" "DevOps_VPC" {
    cidr_block           = var.vpcCIDRblock
    instance_tenancy     = var.instanceTenancy 
    enable_dns_support   = var.dnsSupport 
    enable_dns_hostnames = var.dnsHostNames
    tags = {
        Name = "DevOps VPC"
    }
} 


# create the Subnet
resource "aws_subnet" "DevOps_VPC_Subnet" {
    vpc_id                  = aws_vpc.DevOps_VPC.id
    cidr_block              = var.subnetCIDRblock
    map_public_ip_on_launch = var.mapPublicIP 
    availability_zone       = var.availabilityZone
    tags = {
        Name = "DevOps VPC Subnet"
    }
} 


# create VPC Network access control list
resource "aws_network_acl" "DevOps_VPC_Security_ACL" {
    vpc_id = aws_vpc.DevOps_VPC.id
    subnet_ids = [ aws_subnet.DevOps_VPC_Subnet.id ]
    # allow ingress port 22
    ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 22
    to_port    = 22
    }

    # allow ingress port 80 
    ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 80
    to_port    = 80
    }

    # allow ingress ephemeral ports 
    ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
    }

    # allow egress port 22 
    egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22 
    to_port    = 22
    }

    # allow egress port 80 
    egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80  
    to_port    = 80 
    }

    # allow egress ephemeral ports
    egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
    }
    tags = {
        Name = "DevOps VPC ACL"
    }
} 


# Create the Route Table
resource "aws_route_table" "DevOps_VPC_route_table" {
    vpc_id = aws_vpc.DevOps_VPC.id
    tags = {
        Name = "DevOps VPC Route Table"
    }   
}


# Associate the Route Table with the Subnet
resource "aws_route_table_association" "DevOps_VPC_association" {
    subnet_id      = aws_subnet.DevOps_VPC_Subnet.id
    route_table_id = aws_route_table.DevOps_VPC_route_table.id
}


# Create the Internet Gateway
resource "aws_internet_gateway" "DevOps_VPC_GW" {
    vpc_id = aws_vpc.DevOps_VPC.id
    tags = {
        Name = "DevOps VPC Internet Gateway"
    }
}


# Create the Internet Access
resource "aws_route" "DevOps_VPC_internet_access" {
    route_table_id         = aws_route_table.DevOps_VPC_route_table.id
    destination_cidr_block = var.destinationCIDRblock
    gateway_id             = aws_internet_gateway.DevOps_VPC_GW.id
} 


# Create the Security Group
resource "aws_security_group" "DevOps_VPC_Security_Group" {
    vpc_id       = aws_vpc.DevOps_VPC.id
    name         = "DevOps VPC Security Group"
    description  = "DevOps VPC Security Group"

    # allow ingress of port 22
    ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    } 

    # allow egress of all ports
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "DevOps VPC Security Group"
        Description = "DevOps VPC Security Group"
    }
} 