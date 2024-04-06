# Declare Provider
provider "aws" {
  access_key = "AKIATCKAORVR2LRBXT5S"
  secret_key = "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"
  region     = "us-east-1"
}
# create vpc
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}
#Create Subnet
resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}
# Create security group 
resource "aws_security_group" "web_server_sg" {
  name        = "web_server_sg"
  description = "allow traffic"
  vpc_id      = aws_vpc.default.id
}
# Create security group rule
resource "aws_security_group_rule" "web_server_sg_HTTP_ipv4" {
  type              = "ingress"
  security_group_id = aws_security_group.web_server_sg.id
  cidr_blocks       = [aws_vpc.default.cidr_block]
  from_port         = 0
  to_port           = 80
  protocol          = "tcp"

}
# Create security group rule
resource "aws_security_group_rule" "web_server_sg_SSH_ipv4" {
  type              = "ingress"
  security_group_id = aws_security_group.web_server_sg.id
  cidr_blocks       = [aws_vpc.default.cidr_block]
  from_port         = 0
  to_port           = 22
  protocol          = "tcp"
}
# Create security group rule
resource "aws_security_group_rule" "web_server_sg_egress_ipv4" {
  type              = "egress"
  security_group_id = aws_security_group.web_server_sg.id
  cidr_blocks       = [aws_vpc.default.cidr_block]
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
}
# Create EC2 instance 
resource "aws_instance" "web_server_instance" {
  ami                    = "ami-0c101f26f147fa7fd"
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet.id
  tags = {
    Name = "web_server_instance"
  }
}
