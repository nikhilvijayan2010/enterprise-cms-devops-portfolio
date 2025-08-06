output "vm_id" {
  description = "The ID of the virtual machine."
  value       = azurerm_windows_virtual_machine.vm.id
}

output "vm_private_ip" {
  description = "The private IP address of the VM."
  value       = azurerm_network_interface.nic.private_ip_address
}

output "vm_public_ip" {
  value = azurerm_public_ip.pip.ip_address
  description = "The public IP of the virtual machine"
}
