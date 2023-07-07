variable "name" {
  type        = string
  description = "name tag value"
}

variable "tags" {
  type        = map(any)
  description = "tags for the vpc module"
}

variable "iam_role_name" {
  type        = string
  description = "iam role name to attach to the instance profile"
}

variable "key_pair_name" {
  type        = string
  description = "keypair to utilize"

}

resource "aws_security_group" "Vera-Security-Group" {
  name        = join("", [var.name, "-", "Vera-Security-Group"])
  description = "Allow  traffic for http and ssh"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = join("", [var.name, "-", "iam-instance-profile"])
  role = var.iam_role_name
}



resource "aws_instance" "web_server" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t3.large"
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.Vera-Security-Group.id]
  user_data              = file("scripts/userdata.sh")
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  tags                   = merge(var.tags, { Name = join("", [var.name, "-", "webserver"]) }, { Environment = var.name })

  # best practices as per checkov scanner

  monitoring    = true
  ebs_optimized = true
  root_block_device {
    encrypted = true
  }

}
