#Create AWS VPC
resource "aws_vpc" "jenkins-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
 

  tags = {
    Name = var.vpc_name 
  }
}