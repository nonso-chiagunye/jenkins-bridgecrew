# Route table for the public subnets
resource "aws_route_table" "jenkins-bastion-routes" {
  vpc_id = aws_vpc.jenkins-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins-igw.id
  }

  tags = {
    Name = var.public_routes_name 
  }
}

# Route table for the private subnets
resource "aws_route_table" "jenkins-private-routes" {
  vpc_id = aws_vpc.jenkins-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.jenkins-ngw.id
  }

  tags = {
    Name = var.private_routes_name 
  }
}

# Route associations public
resource "aws_route_table_association" "jenkins-bation" {
  subnet_id      = aws_subnet.jenkins-bastion.id
  route_table_id = aws_route_table.jenkins-bastion-routes.id
}
# Route associations public
resource "aws_route_table_association" "jenkins-public" {
  subnet_id      = aws_subnet.jenkins-public.id
  route_table_id = aws_route_table.jenkins-bastion-routes.id
}
# Route associations private
resource "aws_route_table_association" "jenkins-private-1" {
  subnet_id      = aws_subnet.jenkins-private-1.id
  route_table_id = aws_route_table.jenkins-private-routes.id
}
# Route associations private
resource "aws_route_table_association" "jenkins-private-2" {
  subnet_id      = aws_subnet.jenkins-private-2.id
  route_table_id = aws_route_table.jenkins-private-routes.id
}
