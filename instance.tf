
resource "aws_kms_key" "test-kms" {
  description             = "Encrypt Test EBS Volume"
  deletion_window_in_days = 7
}

resource "aws_security_group" "test-sg" {
  vpc_id      = "vpc-6ffe7f04"
  name        = "test-sg"
  description = "test security group"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["91.73.64.16/32"]
  }
  
  tags = {
    Name = "test-sgs"
  }
}

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
  subnet_id = "subnet-0d993066"
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