variable "vpc_cidr" {
  type = string
  default = "192.168.0.0/16"
  
}

variable "subnet_cidrs" {
  type = list(string)
  default = [ "192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24", "192.168.40.0/24" ]
}

variable "jenkins_ext_ports" {
  type = list(number)
  default = [ 443, 8080, 80, 9418 ]  
}

variable "AWS_REGION" {
default = "us-east-2"
}

variable "KEY_NAME" {
  type = string
  default = ""
  
}

variable "volume_type" {
  type = string
  default = "gp3"  
}

variable "volume_size" {
  type = number
  default = 100  
}

variable "volume_iops" {
  type = number
  default = 16000  
}

variable "throughput" {
  type = number
  default = 800  
}

variable "deletion_window_in_days" {
  type = number
  default = 7  
}

variable "path_to_key" {
  type = string
  default = ""  
}

variable "My_IP" {
  type = string
  default = ""  
}

variable "key_destination" {
  type = string
  default = "/home/ubuntu/key-name.pem"  
}

variable "tfstate_bucket" {
  type = string
  default = "my-tfstate-file-location"  
}

variable "tfstate_bucket_key" {
  type = string
  default = "main"  
}

variable "dynamodb_lock" {
  type = string
  default = "my-tfstate-lock"  
}

variable "jenkins_igw" {
  type = string
  default = "jenkins-igw"  
}

variable "jenkins_server_ami" {
  type = string
  default = "ami-06d4b7182ac3480fa"  // Amazon linux
}

variable "jenkins_instance_type" {
  type = string
  default = "t3.xlarge"  
}

variable "jenkins_server" {
  type = string
  default = ""  
}

variable "bastion_server" {
  type = string
  default = ""  
}

variable "target_group_name" {
  type = string
  default = "jenkins-alb-target-group"  
}

variable "load_balancer_name" {
  type = string
  default = ""  
}

variable "public_routes_name" {
  type = string
  default = ""  
}

variable "private_routes_name" {
  type = string
  default = ""  
}

variable "bastion_subnet_name" {
  type = string
  default = ""  
}

variable "jenkins_public_subnet" {
  type = string
  default = ""  
}

variable "private_subnet_1" {
  type = string
  default = ""  
}

variable "private_subnet_2" {
  type = string
  default = ""  
}

variable "vpc_name" {
  type = string
  default = ""  
}