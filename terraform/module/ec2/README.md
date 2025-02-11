
main.tf

# Define multiple providers with an alias for cross-region deployment
provider "aws" {
  region = var.default_region
}

# Define provider for additional regions dynamically
provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

# Fetch latest Ubuntu AMI in both regions
data "aws_ami" "latest_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu--20.04-amd64-server-"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# Create EC2 instance in the primary region
resource "aws_instance" "primary_ec2" {
  provider               = aws
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.primary_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.primary_sg_ids

  tags = merge(var.tags, { "Region" = var.default_region, "Name" = "primary-ec2" })
}

# Create EC2 instance in the secondary region
resource "aws_instance" "secondary_ec2" {
  provider               = aws.secondary
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.secondary_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.secondary_sg_ids

  tags = merge(var.tags, { "Region" = var.secondary_region, "Name" = "secondary-ec2" })
}

# Define input variables
variable "default_region" {
  description = "Primary AWS region"
  type        = string
}

variable "secondary_region" {
  description = "Secondary AWS region"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "primary_subnet_id" {
  description = "Subnet ID for primary region"
  type        = string
}

variable "secondary_subnet_id" {
  description = "Subnet ID for secondary region"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair Name"
  type        = string
}

variable "primary_sg_ids" {
  description = "List of security groups for primary region"
  type        = list(string)
}

variable "secondary_sg_ids" {
  description = "List of security groups for secondary region"
  type        = list(string)
}

variable "tags" {
  description = "Tags for the EC2 instance"
  type        = map(string)
  default = {
    Project = "alpha"
    Owner   = "edemos"
    Env     = "Dev"
  }
}

# Output instance details
output "primary_instance_public_ip" {
  description = "Public IP of primary EC2 instance"
  value       = aws_instance.primary_ec2.public_ip
}

output "secondary_instance_public_ip" {
  description = "Public IP of secondary EC2 instance"
  value       = aws_instance.secondary_ec2.public_ip
}




terraform.tfvar 

default_region     = "us-east-1"
secondary_region   = "us-west-1"
instance_type      = "t2.micro"
primary_subnet_id  = "subnet-062b4d4730c5cc51a"
secondary_subnet_id = "subnet-0abcd1234ef56789"
key_name           = "s7"
primary_sg_ids     = ["sg-0e77f23e754a4e7a4"]
secondary_sg_ids   = ["sg-0a1b2c3d4e5f67890"]