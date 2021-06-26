output "id" {
  description = "List of IDs of instances"
  value       = aws_instance.this.*.id
}

output "arn" {
  description = "List of ARNs of instances"
  value       = aws_instance.this.*.arn
}

output "private_ip" {
  description = "List of Private IP's of instances"
  value       = aws_instance.this.*.private_ip
  }
