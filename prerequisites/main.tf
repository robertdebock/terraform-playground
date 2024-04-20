# Create a key.
resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Upload a key to AWS.
resource "aws_key_pair" "default" {
  key_name   = "lab"
  public_key = tls_private_key.default.public_key_openssh
}

# Save the private key to a file.
resource "local_file" "private" {
  filename        = "id_rsa"
  content         = tls_private_key.default.private_key_openssh
  file_permission = 0600
}

# Create a VPC.
resource "aws_vpc" "default" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name  = "my-instance-vpc"
    owner = "Robert de Bock"
  }
}

# Create a security group.
resource "aws_security_group" "default" {
  name        = "my-instance-sg"
  description = "Allow traffic."
  vpc_id      = aws_vpc.default.id
  tags = {
    Name  = "my-instance-vpc"
    owner = "Robert de Bock"
  }
}

# Allow incoming traffic on port 22.
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

# Allow outgoing traffic.
resource "aws_security_group_rule" "all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

# Find available availability zones.
data "aws_availability_zones" "default" {
  state         = "available"
  exclude_names = ["us-east-1e"]
}

# Pick a random availability zone.
resource "random_shuffle" "default" {
  input        = data.aws_availability_zones.default.names
  result_count = 1
}

# Create a subnet.
resource "aws_subnet" "default" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, 8, 23)
  availability_zone = random_shuffle.default.result[0]
  tags = {
    Name  = "my-instance-vpc"
    owner = "Robert de Bock"
  }
}

# Create a route table.
resource "aws_route_table" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name  = "my-instance-vpc"
    owner = "Robert de Bock"
  }
}

# Create a route to the internet.
resource "aws_route" "default" {
  route_table_id         = aws_route_table.default.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# Associate the route table with the subnet.
resource "aws_route_table_association" "default" {
  subnet_id      = aws_subnet.default.id
  route_table_id = aws_route_table.default.id
}

# Create an internet gateway.
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name  = "my-instance-vpc"
    owner = "Robert de Bock"
  }
}
