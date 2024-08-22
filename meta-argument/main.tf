terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"  # Specifies the AWS provider version to ensure compatibility.
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Specifies the AWS region where resources will be created.
}
/*
resource "aws_iam_group" "grp1" {
    name = "manager24"  # Creates an IAM group with the name "manager".

    # The lifecycle block is used to manage resource behavior in specific cases.
    lifecycle {
      prevent_destroy = false  # This prevents the IAM group from being destroyed even if it is removed from the Terraform configuration. You will need to manually delete it to ensure safety.
    }
}




resource "aws_iam_user" "usr1" {
    name = "serge2024"  # Creates an IAM user with the name "serge2024".

    # The depends_on block explicitly declares that this IAM user depends on the IAM group "grp1".
    # This means Terraform will ensure that the IAM group is created first before attempting to create the user.
    depends_on = [ aws_iam_group.grp1 ]
}


*/

resource "aws_instance" "server1" {
    ami = "ami-033a1ebf088e56e81"
    instance_type = "t2.micro"
    key_name = "north_virginia_dev"

    lifecycle {
      create_before_destroy = true
    }
  
}