#  Import availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Bastion public subnet
resource "aws_subnet" "jenkins-bastion" {
  vpc_id                  = aws_vpc.jenkins-vpc.id
  cidr_block              = var.subnet_cidrs[0]
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.bastion_subnet_name  
  }
}
#  Second public subnet (Here basically because of Load balancer requirement)
resource "aws_subnet" "jenkins-public" {
  vpc_id                  = aws_vpc.jenkins-vpc.id
  cidr_block              = var.subnet_cidrs[3]
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.jenkins_public_subnet
  }
}
#  Private subnet for jenkins server
resource "aws_subnet" "jenkins-private-1" {
  vpc_id                  = aws_vpc.jenkins-vpc.id
  cidr_block              = var.subnet_cidrs[1]
  map_public_ip_on_launch = "false"
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.private_subnet_1 
  }
}
#  Second Private subnet
resource "aws_subnet" "jenkins-private-2" {
  vpc_id                  = aws_vpc.jenkins-vpc.id
  cidr_block              = var.subnet_cidrs[2]
  map_public_ip_on_launch = "false"
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.private_subnet_2
  }
}