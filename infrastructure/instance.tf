#  Create KMS Key to encrypt the Jenkins EBS Volume
resource "aws_kms_key" "jenkins-key" {
  description             = "Encrypt Jenkins EBS Volume"
  deletion_window_in_days = var.deletion_window_in_days
}

#  AMI for the bastion server
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jenkins-server" {
  # ami           = data.aws_ami.ubuntu.id
  ami           = var.jenkins_server_ami
  instance_type = var.jenkins_instance_type
  key_name      = var.KEY_NAME
  iam_instance_profile = aws_iam_instance_profile.jenkins-server-instance-profile.name

  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  subnet_id = aws_subnet.jenkins-private-1.id
  user_data = file("jenkins.sh")

  root_block_device {
    delete_on_termination = true 
    volume_type = var.volume_type
    volume_size = var.volume_size
    iops = var.volume_type == "gp2" ? null : var.volume_iops
    throughput = var.volume_type != "gp3" ? null : var.throughput
    encrypted = true 
    kms_key_id = aws_kms_key.jenkins-key.id 
  }

  tags = {
    Name = var.jenkins_server
  }
}

#  Create a bastion host to connect to jenkins server
resource "aws_instance" "bastion-server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.KEY_NAME
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  subnet_id = aws_subnet.jenkins-bastion.id
#  Upload the private key to bastion, to use it for connection to jenkins server
  provisioner "file" {
    source = "${var.path_to_key}/${var.KEY_NAME}.pem"
    destination = var.key_destination   
  }  

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${var.path_to_key}/${var.KEY_NAME}.pem")
  }

  tags = {
    Name = var.bastion_server  
  }
}
