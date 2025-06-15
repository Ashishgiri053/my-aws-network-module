// modules/aws_network/main.tf

// NO 'provider "aws"' block HERE!

resource "aws_vpc" "custom_vpc" { // Declares aws_vpc named custom_vpc
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.default_tags, { Name = "${var.prefix}-vpc" })
}

resource "aws_subnet" "public_subnet" { // Declares aws_subnet named public_subnet
  vpc_id                  = aws_vpc.custom_vpc.id   // Refers to aws_vpc.custom_vpc
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.avail_zone
  map_public_ip_on_launch = true
  tags = merge(var.default_tags, { Name = "${var.prefix}-public-subnet" })
}

resource "aws_internet_gateway" "igw" { // Declares aws_internet_gateway named igw
  vpc_id = aws_vpc.custom_vpc.id // Refers to aws_vpc.custom_vpc
  tags   = merge(var.default_tags, { Name = "${var.prefix}-igw" })
}

resource "aws_route_table" "public_rt" { // Declares aws_route_table named public_rt
  vpc_id = aws_vpc.custom_vpc.id // Refers to aws_vpc.custom_vpc
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id // Refers to aws_internet_gateway.igw
  }
  tags = merge(var.default_tags, { Name = "${var.prefix}-public-rt" })
}

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id // Refers to aws_subnet.public_subnet
  route_table_id = aws_route_table.public_rt.id  // Refers to aws_route_table.public_rt
}

resource "aws_security_group" "allow_web_ssh" { // Declares aws_security_group named allow_web_ssh
  name        = "${var.prefix}-sg-web-ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.custom_vpc.id // Refers to aws_vpc.custom_vpc

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
    Name = "${var.prefix}-sg-web-ssh"
  })
}