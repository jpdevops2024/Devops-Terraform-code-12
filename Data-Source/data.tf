
  
# This block defines a data source to retrieve information about an AWS AMI (Amazon Machine Image).
# Data sources are used to look up existing resources rather than creating new ones.

data "aws_ami" "ami1" {
  # "most_recent" ensures that the most up-to-date AMI is selected
  most_recent      = true

  # The "owners" argument specifies the account ID of the AMI's owner.
  # In this case, "amazon" refers to AMIs owned by Amazon.
  owners           = ["amazon"]

  # The first filter block narrows down the AMI selection based on the name.
  # We're looking for AMIs that match the pattern "amzn2-ami-kernel-5.10-hvm*-x86_64-ebs".
  # The "*" is a wildcard that allows flexible matching.
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm*-x86_64-ebs"]
  }

  # The second filter ensures that the AMI has an "ebs" root device type,
  # meaning the AMI uses an EBS (Elastic Block Store) volume for its root filesystem.
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  # The third filter ensures that the AMI uses "hvm" (hardware virtualization) as its virtualization type.
  # HVM (Hardware Virtual Machine) AMIs offer better performance, particularly for workloads that require 
  # direct access to hardware resources.
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
