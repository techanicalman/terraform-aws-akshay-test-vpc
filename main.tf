resource "aws_vpc" "main" {
  cidr_block = var.vpc_config.cidr_block
  tags = {
    Name = var.vpc_config.name
  }
}
resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  for_each = var.subnet_config

  cidr_block = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}
# Create IGW only if there's at least one public subnet
resource "aws_internet_gateway" "main" {
  count  = length([for s in var.subnet_config : s if try(s.public, false)]) > 0 ? 1 : 0
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  count  = aws_internet_gateway.main != [] ? 1 : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main[0].id
  }

  tags = {
    Name = "public-rt"
  }
}

# Associate only public subnets with public route table
resource "aws_route_table_association" "public" {
  for_each = {
    for k, s in var.subnet_config : k => s
    if try(s.public, false)
  }

  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.public[0].id
}