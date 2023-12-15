
resource "aws_kms_key" "test-kms" {
  description             = "Encrypt Test EBS Volume"
  deletion_window_in_days = 7
}

# data "aws_ami" "ubuntu" {
#     most_recent = true

#     filter {
#         name   = "name"
#         values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#     }

#     filter {
#         name   = "virtualization-type"
#         values = ["hvm"]
#     }

#     owners = ["099720109477"] # Canonical
# }

# resource "aws_instance" "jenkins-server" {
#   # ami           = data.aws_ami.ubuntu.id
#   ami           = "ami-06d4b7182ac3480fa"
#   instance_type = "t2.micro"
#   # key_name      = var.KEY_NAME
#   # iam_instance_profile = aws_iam_instance_profile.jenkins-server-instance-profile.name

#   vpc_security_group_ids = [aws_security_group.test-sg.id]
#   subnet_id = "subnet-0088c31ea8f945b10"
#   # user_data = file("jenkins.sh")

#   root_block_device {
#     delete_on_termination = true 
#     volume_type = "gp2"
#     volume_size = "10"
#     # iops = var.volume_type == "gp2" ? null : var.volume_iops
#     # throughput = var.volume_type != "gp3" ? null : var.throughput
#     encrypted = true 
#     kms_key_id = aws_kms_key.test-kms.id 
#   }

#   tags = {
#     Name = "test-kms"
#   }
# }

# resource "aws_instance" "jump-server" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t2.micro"
#   key_name      = var.KEY_NAME
#   vpc_security_group_ids = [aws_security_group.jump-server-sg.id]
#   subnet_id = aws_subnet.jenkins-public.id

#   provisioner "file" {
#     source = "${var.path_to_key}/${var.KEY_NAME}.pem"
#     destination = var.key_destination   
#   }  

#   connection {
#     host        = coalesce(self.public_ip, self.private_ip)
#     type        = "ssh"
#     user        = "ubuntu"
#     private_key = file("${var.path_to_key}/${var.KEY_NAME}.pem")
#   }

#   tags = {
#     Name = "jump-server"
#   }
# }


resource "aws_instance" "test-server" {
  # ami           = data.aws_ami.ubuntu.id
  ami           = "ami-06d4b7182ac3480fa"
  # monitoring = true
  # ebs_optimized = true
  instance_type = "t2.micro"
  metadata_options {
    http_endpoint = "disabled"
   }
  # key_name      = var.KEY_NAME
  # iam_instance_profile = aws_iam_instance_profile.jenkins-server-instance-profile.name

  vpc_security_group_ids = [aws_security_group.test-sg.id]
  subnet_id = "subnet-0088c31ea8f945b10"
  # user_data = file("jenkins.sh")

  root_block_device {
    delete_on_termination = true 
    volume_type = "gp2"
    volume_size = "10"
    # iops = var.volume_type == "gp2" ? null : var.volume_iops
    # throughput = var.volume_type != "gp3" ? null : var.throughput
    encrypted = true 
    kms_key_id = aws_kms_key.test-kms.id 
  }

  tags = {
    Name = "test-kms"
  }
}