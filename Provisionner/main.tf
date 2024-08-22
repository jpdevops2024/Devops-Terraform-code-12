

# Define the required providers and the specific version for the AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"  # Source for AWS provider
      version = "4.61.0"         # Specify the AWS provider version
    }
  }
}

# AWS provider configuration, specifying the region where resources will be created
provider "aws" {
  region = "us-east-1"  # Region where resources will be deployed
}

# Generate a secure private key using the TLS provider
resource "tls_private_key" "my_ec2_key" {
  algorithm = "RSA"   # Algorithm used for key generation (RSA)
  rsa_bits  = 2048    # Number of bits for the key, 2048 is secure and commonly used
}

# Create an AWS Key Pair using the public part of the generated key
resource "aws_key_pair" "ec2_key" {
  key_name   = "week12key"  # Name of the key pair in AWS
  public_key = tls_private_key.my_ec2_key.public_key_openssh  # Public key in OpenSSH format
}

# Save the private key locally in PEM format for secure SSH access to the EC2 instance
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.ec2_key.key_name}.pem"  # The file name for the private key (.pem)
  content  = tls_private_key.my_ec2_key.private_key_pem  # Private key content in PEM format
}

# Create an EC2 instance using a specified Amazon Machine Image (AMI) and instance type
resource "aws_instance" "demo1" {
  ami           = "ami-033a1ebf088e56e81"  # Amazon Machine Image (AMI) ID
  instance_type = "t2.micro"               # Instance type (t2.micro, eligible for free tier)
  key_name      = "week12key"              # Key pair for SSH access to the instance
}

# Null resource used to run provisioners like local-exec and remote-exec
resource "null_resource" "n1" {
  # SSH connection to the EC2 instance using the private key
  connection {
    type        = "ssh"                          # Connection type: SSH
    user        = "ec2-user"                     # User for SSH (default user for Amazon Linux)
    private_key = file(local_file.ssh_key.filename)  # Private key file for authentication
    host        = aws_instance.demo1.public_ip   # Public IP of the EC2 instance
  }

  # Provisioner to run a local command (runs on the machine where Terraform is executed)
  provisioner "local-exec" {
    command = "echo hello"  # Example command that prints "hello" to the local terminal
  }

  # Provisioner to execute commands on the remote EC2 instance
  provisioner "remote-exec" {
    inline = [
      "sudo useradd serge1",   # Command to add a new user named "serge1" on the EC2 instance
      "mkdir terraform1",      # Command to create a directory named "terraform1" on the instance
    ]
  }

  # Provisioner to copy a local file to the remote EC2 instance
  provisioner "file" {
    source      = "week12key.pem"   # Local file to be copied
    destination = "/tmp/key.pem"    # Destination path on the EC2 instance
  }

  # Define dependencies to ensure resources are created in the correct order
  depends_on = [ aws_instance.demo1, local_file.ssh_key ]  # Ensures the EC2 instance and SSH key exist before provisioners run
}
