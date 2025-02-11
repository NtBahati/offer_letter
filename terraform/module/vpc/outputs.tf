# outputs.tf
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnets" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "nat_gateways" {
  value = [for nat in aws_nat_gateway.nat : nat.id]
}

# output "security_group_id" {
#   value = aws_security_group.main_sg.id
# }

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "elastic_ip_id" {
  value = aws_eip.main.id
}
