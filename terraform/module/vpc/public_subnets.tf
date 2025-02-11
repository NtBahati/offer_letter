resource "aws_subnet" "public" {
  for_each = { for idx, az in var.availability_zones : idx => az }
  
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, each.key)
  availability_zone       = each.value
  map_public_ip_on_launch = true
  tags                    = merge(var.common_tags, { Name = format("public-subnet-%s", each.value) })
}
