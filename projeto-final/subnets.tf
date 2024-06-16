resource "aws_subnet" "willedy" {
  count                   = 2
  vpc_id                  = aws_vpc.willedy.id
  cidr_block              = cidrsubnet(aws_vpc.willedy.cidr_block, 8, count.index)
  availability_zone       = element(["us-east-1a", "us-east-1b"], count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-subnet-willedy-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.willedy.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "willedy" {
  vpc_id = aws_vpc.willedy.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}-route-table-willedy"
  }
}

resource "aws_route_table_association" "a" {
  count          = 2
  subnet_id      = element(aws_subnet.willedy.*.id, count.index)
  route_table_id = aws_route_table.willedy.id
}