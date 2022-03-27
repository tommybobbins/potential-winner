output "Web-Server-URL" {
  description = "Web-Server-URL"
  value       = join("", ["http://", aws_instance.my-instance.public_ip])
}

output "Time-Date" {
  description = "Date/Time of Execution"
  value       = timestamp()
}

output "SSH-string" {
  description = "Web-Server-URL"
  value       = join("", ["ssh -i ${var.project_name}.pem -oPort=2020 ec2-user@", aws_instance.my-instance.public_ip])
}
