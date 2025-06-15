// modules/aws_network/output.tf
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.custom_vpc.id
}
output "subnet_id" {
  description = "The ID of the created public subnet"
  value       = aws_subnet.public_subnet.id
}
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}
output "route_table_id" {
  description = "The ID of the public Route Table"
  value       = aws_route_table.public_rt.id
}
output "sg_allow_ssh_http_id" {
  description = "The ID of the Security Group"
  value       = aws_security_group.allow_web_ssh.id
}