variable "project" {
  description = "The name of the project"
}

variable "env" {
  description = "The name of the environment"
}

variable "instance_name" {
  description = "Name to be used on all resources as prefix"
  default     = ""
}

variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "ami_id" {
  description = "ID of AMI to use for the instance"
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = false
}

variable "instance_type" {
  description = "The type of instance to start"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key name to use for the instance"
}

variable "enable_detailed_monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "A list of VPC Subnet IDs to launch in."
}

variable "associate_public_ip_address" {
  description = "If true, the EC2 instance will have associated public IP address"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "The IAM Instance Profile to launch the instance with"
  type        = string
  default     = ""
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  type        = map
  default     = {}
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance"
  type        = list(map(string))
  default     = []
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(map(string))
  default     = []
}

variable "ebs_volume_enabled" {
  description = "Flag to control the ebs creation."
  type        = bool
  default     = false
}

variable "ebs_volume_size" {
  description = "Size of the EBS volume in gigabytes."
  type        = number
  default     = 10
}

variable "ebs_volume_type" {
  description = "The type of EBS volume. Can be standard, gp2 or io1."
  default     = "gp3"
}

variable "ebs_gp3_iops" {
  description = "The iops for gp3 EBS volume."
  default     = 3000
}

variable "ebs_device_name" {
  description = "Name of the EBS device to mount."
  type        = list(string)
  default     = ["/dev/xvdb", "/dev/xvdc", "/dev/xvdd", "/dev/xvde", "/dev/xvdf", "/dev/xvdg", "/dev/xvdh", "/dev/xvdi", "/dev/xvdj", "/dev/xvdk", "/dev/xvdl", "/dev/xvdm", "/dev/xvdn", "/dev/xvdo", "/dev/xvdp", "/dev/xvdq", "/dev/xvdr", "/dev/xvds", "/dev/xvdt", "/dev/xvdu", "/dev/xvdv", "/dev/xvdw", "/dev/xvdx", "/dev/xvdy", "/dev/xvdz"]
}

variable "ebs_iops" {
  description = "Amount of provisioned IOPS. This must be set with a volume_type of io1."
  type        = number
  default     = 0
}

variable "ebs_encrypted" {
  description = "Set EBS volume encryption to true or false."
  default     = true
}
