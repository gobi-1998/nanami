provider "aws" {
}


resource "aws_vpc" "test-vpc" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Public-subnet"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Private-subnet"
  }
}


resource "aws_security_group" "test_access" {
  name        = "test_access"
  description = "allow ssh and http"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.test-vpc.id

  tags = {
    Name = "test-igw"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public-asso" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_key_pair" "ltitestkey" {
  key_name   = "ltitestkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhsbhGzMMX78YrbATVYiY6SY8EXdIBeB4UugENxCj9Q26mhQosT2DjEnjwDBA+7qlEZbWh8pkrhmvNccW/9YU4HDz/SF8/SX0YSJVitKGqDvA1mxQzABivJE1whM+Syp5fDnSShayXQUkL+ecyZ2j50z0rSpiDRi8uNtnJVRaYac8fSiuyNlkLNz8+6CcD1Me5iCGN1XfRKZYuwrsCZU1y6Hj+cHnPyiR6DWftaYCn50J5xoBfkdy7NAZIQC7A85GxXsaQe0mMx5R8UYdoa0NAvc4u0QFJUm8Gibl/lkifMZ9G/qTMULuh5e8TZiBOX9dWFcZWXtNOSZK6Mqw09UHJ3OoBH35iJfkskcjFG+Doiikw2g7yMzsM9OOjY0EhSQYp2XdbRGsnYJvlgMvTFCWCa3W5MdGqSDUZI+ucZCcdb36JU7g3iiQuZMIShtd33cOypWGU6yq49ajIKj+74IQpVgboYOgzFzHPYNkQN/030KMBbRyK9LnRoGWB0QYSUrE= root@ip-172-31-90-169.ec2.internal"
}

resource "aws_instance" "sanjay-server" {
  ami             = "ami-05c13eab67c5d8861"
  subnet_id       = aws_subnet.public-subnet.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.ltitestkey.key_name

  tags = {
    Name     = "test-World"
    Stage    = "testing"
    Location = "chennai"
  }
}

resource "aws_eip" "sanjay-ec2-eip" {
  instance = aws_instance.sanjay-server.id
}

resource "aws_instance" "gautam-server" {
  ami             = "ami-05c13eab67c5d8861"
  subnet_id       = aws_subnet.private-subnet.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.ltitestkey.key_name

  tags = {
    Name     = "gautam-World"
    Stage    = "stage-base"
    Location = "delhi"
  }
}

resource "aws_eip" "nat-eip" {}

resource "aws_nat_gateway" "my-ngw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public-subnet.id
}

resource "aws_route_table" "pri-rt" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my-ngw.id
  }

  tags = {
    Name = "pri-rt"
  }
}

resource "aws_route_table_association" "private-asso" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.pri-rt.id
}
