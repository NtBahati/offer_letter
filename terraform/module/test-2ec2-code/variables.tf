
# Define input variables
variable "primary_region" {
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

variable "primary_key_name" {
  description = "EC2 Key Pair Name"
  type        = string
}

variable "secondary_key_name" {
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
    Name = "offer"
    project = "terraform"
    owner = "Bahati"
    env = "dev"
    org = "peacedescendants.org"
  }
}
