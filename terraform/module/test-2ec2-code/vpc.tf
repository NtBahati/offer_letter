# vpc.tf
resource "aws_vpc" "primary_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Primary_VPC"
  }
}

resource "aws_vpc" "secondary_vpc" {
  provider   = aws.secondary
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "Secondary_VPC"
  }
}

# subnet.tf
resource "aws_subnet" "primary_subnet" {
  vpc_id            = aws_vpc.primary_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Primary_Subnet"
  }
}

resource "aws_subnet" "secondary_subnet" {
  provider          = aws.secondary
  vpc_id            = aws_vpc.secondary_vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-west-1b"
  tags = {
    Name = "Secondary_Subnet"
  }
}
