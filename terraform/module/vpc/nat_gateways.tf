resource "aws_eip" "nat" {
  for_each = aws_subnet.public
  
  vpc  = true
  tags = merge(var.common_tags, { Name = format("nat-eip-%s", each.key) })
}

resource "aws_nat_gateway" "nat" {
  for_each = aws_subnet.public
  
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  tags          = merge(var.common_tags, { Name = format("nat-gateway-%s", each.value.availability_zone) })
}
