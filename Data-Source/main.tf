


terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.61.0"
    }
  }
}

provider "aws" {
  
  region = "us-east-1"
}




# This block retrieves data about an existing AWS EC2 instance.
# It fetches information from an EC2 instance using its "instance_id".
data "aws_instance" "ec21" {
  # "instance_id" is the ID of the EC2 instance you want to retrieve information from.
  instance_id = "i-046ef12c0b8537b0d"
}

# This block defines a new EC2 instance resource, which will be created by Terraform.
resource "aws_instance" "demo" {
    # The AMI (Amazon Machine Image) for this EC2 instance is fetched from the data source (existing instance).
    ami = data.aws_instance.ec21.ami

    # The instance type (like t2.micro, t2.medium) is also copied from the existing instance.
    instance_type = data.aws_instance.ec21.instance_type

    # The key pair used for SSH access is fetched from the existing instance's data as well.
    key_name = data.aws_instance.ec21.key_name
}
