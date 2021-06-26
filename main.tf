locals {
  instance_name = var.instance_name == "" ? "${var.project}-ec2-${var.env}" : var.instance_name
  ebs_iops      = var.ebs_volume_type == "io1" ? var.ebs_iops : var.ebs_gp3_iops
}

resource "aws_instance" "this" {
  count                       = var.instance_count
  ami                         = var.ami_id
  subnet_id                   = element(distinct(compact(concat(var.subnet_ids))), count.index)
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = var.security_group_ids
  user_data                   = var.user_data
  iam_instance_profile        = var.iam_instance_profile
  monitoring                  = var.enable_detailed_monitoring
  associate_public_ip_address = var.associate_public_ip_address
  ebs_optimized               = var.ebs_optimized

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", true)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
    }
  }

  volume_tags = merge(var.common_tags, map(
    "Name", format("${local.instance_name}-%d", count.index + 1)
  ))

  tags = merge(var.common_tags, map(
    "Name", format("${local.instance_name}-%d", count.index + 1)
  ))

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      private_ip,
      root_block_device,
      ebs_block_device
    ]
  }

}

resource "aws_ebs_volume" "this" {
  count = var.ebs_volume_enabled == true ? var.instance_count : 0

  availability_zone = element(aws_instance.this.*.availability_zone, count.index)
  size              = var.ebs_volume_size
  iops              = local.ebs_iops
  type              = var.ebs_volume_type
  encrypted         = var.ebs_encrypted

  tags = merge(var.common_tags, map(
    "Name", format("${local.instance_name}-%d", count.index + 1)
  ))
}

resource "aws_volume_attachment" "this" {
  count = var.ebs_volume_enabled == true ? var.instance_count : 0

  device_name = element(var.ebs_device_name, count.index)
  volume_id   = element(aws_ebs_volume.this.*.id, count.index)
  instance_id = element(aws_instance.this.*.id, count.index)
}
