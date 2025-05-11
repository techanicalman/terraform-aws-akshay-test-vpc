output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [
    for k, s in aws_subnet.main : 
    s.id if try(var.subnet_config[k].public, false)
  ]
}
