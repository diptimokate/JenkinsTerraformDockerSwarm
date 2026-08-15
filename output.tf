output "Ansible-public-ip" {
 	description = "Public IP address Manager"
  	value = aws_instance.Ansible.public_ip
}
#=====================Public IP Of All Workers=================================== 
output "manager-pulic-ip" {
 	description = "Public IP address of manager"
  	value = aws_instance.manager.public_ip
}
output "worker1-pulic-ip" {
 	description = "Public IP address of worker1"
  	value = aws_instance.worker1.public_ip
}
