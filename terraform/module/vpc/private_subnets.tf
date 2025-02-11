resource "aws_subnet" "private" {
  for_each = { for idx, az in var.availability_zones : idx => az }
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, each.key + 3)
  availability_zone = each.value
  tags              = merge(var.common_tags, { Name = format("private-subnet-%s", each.value) })
}
