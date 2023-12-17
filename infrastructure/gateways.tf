#Define External IP 
resource "aws_eip" "jenkins-eip" {
  domain = "vpc"
}

# Custom internet Gateway
resource "aws_internet_gateway" "jenkins-igw" {
  vpc_id = aws_vpc.jenkins-vpc.id

  tags = {
    Name = var.jenkins_igw 
  }
}

# Nat Gateway for Private Subnets
resource "aws_nat_gateway" "jenkins-ngw" {
  allocation_id = aws_eip.jenkins-eip.id
  subnet_id     = aws_subnet.jenkins-bastion.id
  depends_on    = [aws_internet_gateway.jenkins-igw]
}


