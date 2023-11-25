resource "null_resource" "ansible-provision" {
  depends_on = ["azurerm_linux_virtual_machine.ubuntu", "azurerm_network_interface.ubuntu"]

  provisioner "local-exec" {
    command = "echo \"[swarm-master]\" > ../cluster-config/swarm-inventory"
  }

  provisioner "local-exec" {
    command = "echo \"${format("%s ansible_ssh_user=%s", azurerm_public_ip.ubuntu.0.ip_address, var.username)}\" >> ../cluster-config/swarm-inventory"
  }

  provisioner "local-exec" {
    command = "echo \"[swarm-nodes]\" >> ../cluster-config/swarm-inventory"
  }

  provisioner "local-exec" {
    command = "echo \"${join("\n",formatlist("%s ansible_ssh_user=%s", azurerm_public_ip.ubuntu[*].ip_address, var.username))}\" >> ../cluster-config/swarm-inventory"
  }
}