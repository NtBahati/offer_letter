resource "aws_eip" "main" {
  vpc  = true
  tags = merge(var.common_tags, { Name = format("main-eip") })
}
