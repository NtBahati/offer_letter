resource "aws_eip" "ec2_eip" {
  instance = aws_instance.ec2_instance.id
}