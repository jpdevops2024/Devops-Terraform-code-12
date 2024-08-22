# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "aws_instance" "web" {
  ami                                  = "ami-0c8e23f950c7725b9"
  associate_public_ip_address          = true
  availability_zone                    = "us-east-1b"
  instance_type                        = "t2.micro"
  key_name                             = "north_virginia_dev"
  security_groups                      = ["launch-wizard-3"]
  subnet_id                            = "subnet-0014a1373449d528c"
  tags = {
    Name = "created by terraform"
  }
  tags_all = {
    Name = "webserver"
  }
}
