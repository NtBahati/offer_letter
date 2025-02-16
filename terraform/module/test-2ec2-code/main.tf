
# Define multiple providers with an alias for cross-region deployment
provider "aws" {
    region = var.primary_region
}

# Define provider for additional regions dynamically
provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

## Terraform block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
# data "aws_ami" "ubuntu-primary" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"] # Replace `20.04` with your preferred version
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical's owner ID for Ubuntu AMIs
# }

# data "aws_ami" "ubuntu-secondary" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"] # Replace `20.04` with your preferred version
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical's owner ID for Ubuntu AMIs
# }

# # Create EC2 instance in the primary region
# resource "aws_instance" "primary_ec2" {
#   provider               = aws
#   ami                    = data.aws_ami.ubuntu-primary.id
#   instance_type          = var.instance_type
#   subnet_id              = var.primary_subnet_id
#   key_name               = var.key_name
#   vpc_security_group_ids = var.primary_sg_ids

#   tags = merge(var.tags, { "Region" = var.primary_region, "Name" = "primary-ec2" })
# }

# # Create EC2 instance in the secondary region
# resource "aws_instance" "secondary_ec2" {
#   provider               = aws.secondary
#   ami                    = data.aws_ami.ubuntu-secondary.id
#   instance_type          = var.instance_type
#   subnet_id              = var.secondary_subnet_id
#   key_name               = var.key_name
#   vpc_security_group_ids = var.secondary_sg_ids

#   tags = merge(var.tags, { "Region" = var.secondary_region, "Name" = "secondary-ec2" })
# }



# Fetch the latest Ubuntu AMI in the primary region
data "aws_ami" "ubuntu_primary" {
  provider    = aws # Uses primary region
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's owner ID for Ubuntu AMIs
}

# Fetch the latest Ubuntu AMI in the secondary region
data "aws_ami" "ubuntu_secondary" {
  provider    = aws.secondary # Uses secondary region
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
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
  ami                    = data.aws_ami.ubuntu_primary.id
  instance_type          = var.instance_type
  subnet_id              = var.primary_subnet_id
  key_name               = var.primary_key_name
  vpc_security_group_ids = var.primary_sg_ids

  tags = merge(var.tags, { "Region" = var.primary_region, "Name" = "primary-ec2" })
}

# Create EC2 instance in the secondary region
resource "aws_instance" "secondary_ec2" {
  provider               = aws.secondary
  ami                    = data.aws_ami.ubuntu_secondary.id
  instance_type          = var.instance_type
  subnet_id              = var.secondary_subnet_id
  key_name               = var.secondary_key_name
  vpc_security_group_ids = var.secondary_sg_ids

  tags = merge(var.tags, { "Region" = var.secondary_region, "Name" = "secondary-ec2" })
}