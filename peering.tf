#VPC peering with default vpc

resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_required ? 1 : 0
  peer_vpc_id = aws_vpc.main.id
  vpc_id = var.requester_vpc_id #default vpc is our requestor
  auto_accept = true

  tags = merge(
    var.common_tags,
    {
      Name = "VPC peering between default vpc and ${var.project_name}"
    }
  )
}

resource "aws_route" "default_route" {
  count = var.is_peering_required ? 1 : 0
  route_table_id = var.default_route_table_id
  destination_cidr_block = var.cidr_block
  #if we set count parameter even single parameter is consider as a list, so we should write list syntax
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "public_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id = aws_route_table.public.id
  destination_cidr_block = var.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "private_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id = aws_route_table.private.id
  destination_cidr_block = var.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
  
}
resource "aws_route" "database_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id = aws_route_table.database.id
  destination_cidr_block = var.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
  
}