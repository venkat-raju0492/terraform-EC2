# terraform-EC2
Common terraform module for AWS Elastic Cloud Compute
- Creates, n number of ec2 instances defined by count
- Optional, add additional ebs volume, user data 


````terraform
terraform {
  backend "s3" {
    encrypt = true
  }
}

provider "aws" {
  region = var.region
}

locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Project     = var.project
    Environment = var.env
    CreatedBy   = "Terraform"
  }
}

//Define data block to get ami id
data "aws_ami" "amznami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }
}

//Define user data
data "template_file" "user_data" {
  template = file("${path.module}/templates/ec2/userdata.sh")
  
  vars = {
    qualys_s3_url = var.qualys_s3_url
  }
}

module "ec2" {
  source                 = "git@github.levi-site.com:LSCO/terraform-EC2.git?ref=<REVISION-VERSION>"
  instance_count         = 1 // Optional, default = 1
  project                = var.project
  env                    = var.env
  instance_type          = "t2.micro" // Optional, default is t2.micro
  ami_id                 = data.aws_ami.amznami.id // AMI ID
  subnet_ids             = ["<SUBNETS-IDS-HERE>"] //Provide multiple single subnet/subnets id
  security_group_ids     = ["<SG-IDS-HERE>"] //SG ID
  key_name               = var.key_name // Key Pair
  user_data              = data.template_file.user_data.rendered //Optional, user data
  common_tags            = local.common_tags //tags
  iam_instance_profile   = "<IAM-INSTANCE-PROFILE-HERE>" //Optional, ec2 instance profile

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = 10 //Encryption is default set true
    }
  ]

  //Optional, add additional EBS volumes
  ebs_volume_enabled          = true
  ebs_volume_type             = "gp3"
  ebs_volume_size             = 30
}

````
