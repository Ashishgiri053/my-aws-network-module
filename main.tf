// modules/aws_network/main.tf
locals {
  // Base name constructed from namespace and stage
  // We'll use this to form specific resource names.
  // Note: The 'name' attribute of aws_security_group must be unique.
  // The 'Name' tag is more flexible.

  common_tags = merge(var.default_tags, { // Merge with tags passed from calling module
    Namespace = var.namespace
    Stage     = var.stage
    // You could add other fixed common tags here if desired
  })
}



resource "aws_vpc" "custom_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.default_tags, {
    Name = "${var.namespace}-${var.stage}-vpc" // UPDATED
  })
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.avail_zone
  map_public_ip_on_launch = true
  tags = merge(var.default_tags, {
    Name = "${var.namespace}-${var.stage}-public-subnet" // UPDATED
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id
  tags   = merge(var.default_tags, {
    Name = "${var.namespace}-${var.stage}-igw" // UPDATED
  })
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.default_tags, {
    Name = "${var.namespace}-${var.stage}-public-rt" // UPDATED
  })
}

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "allow_web_ssh" {
  name        = "${var.namespace}-${var.stage}-sg-web-ssh" // UPDATED attribute
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, {
    Name = "${var.namespace}-${var.stage}-sg-web-ssh" // UPDATED tag
  })
}