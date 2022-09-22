#Directory = /itom-qe/azurecomplexvar1::main
#File1 = provider.tf
#File2 = template.tf
#File3 = var.tf

#File =provider.tf
provider "azurerm" {
  
  subscription_id = "${var.subscriptionId}"
  client_id       = "${var.clientId}"
  client_secret   = "${var.clientSecret}"
  tenant_id       = "${var.tenantId}"
  features {}
 #version = "=1.44.0"
}

#File =template.tf
resource "azurerm_resource_group" "main" {
  name     = "${var.resourceGroup}"
  location = "${var.region}"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["${var.address_space}"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefixes       = ["${var.subnet_prefix}"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "${var.prefix}-ipconfiguration"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-azure-vm"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "${var.vmSize[1]["type2"]}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku["image1"]}"
    version   = "${var.image_version}"
  }
  storage_os_disk {
    name              = "${var.prefix}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.hostname}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = var.environment[2]["env"]
  }
}
resource "azurerm_public_ip" "test" {
  name                = "${var.prefix}-PublicIp"
  location            = "${var.region}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  allocation_method   = "Static"

  tags = {
    Name = var.mapvar["name"]
  }
}
resource "azurerm_managed_disk" "example" {
  name                 = "${var.prefix}-azure-vm-disk1"
  location             = "${azurerm_resource_group.main.location}"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "${var.diskSizeInGB}"

  tags = var.objectVar
}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = "${azurerm_managed_disk.example.id}"
  virtual_machine_id = "${azurerm_virtual_machine.main.id}"
  lun                = "10"
  caching            = "ReadWrite"
}

#File =var.tf
variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "region" {
  description = "The Azure Region in which all resources in this example should be created"
}


variable "subscriptionId" {}
variable "clientId" {}
variable "clientSecret" {}
variable "resourceGroup" {}
variable "tenantId" {}
variable "diskSizeInGB" {

description = "Disk size of the managed Disk."
  default     = "1"
}

variable "imageset" {
  type = set(string)
  default = [
  "image 1",
  "image 2", "image 3"]
}

variable "listType" {
 type        = list
  default     = ["t2.micro", #comment
          "m1.small" // comment ..,
           ]
 description = "Instance types for the EC2 instance"
 /*
  multiline 
  * comment
 */
}

variable "environment" {
 type = tuple([bool, bool, object({
   name = string
   env  = string,
   isAvailable = bool
 })
 ])
 /***
 comment
 commment
 */
 default = [false, true,{
   name : "vpc-0163eb001426736ac"
   //commment .......,
   env  : "Dev",
   isAvailable : true
 }]
 description = "Subnet ID for network interface"
}

variable "vmSize" {
  description = "Specifies the size of the virtual machine."
  default = [true, {
    type1 = "m1.small"
    "type2"   = "Standard_D1_v2",
    type3 : "m1.medium"
  }]
}


variable "admin_username" {
  description = "administrator user name"
  default     = "vmadmin"
}

variable "admin_password" {
  description = "administrator password (recommended to disable password auth)"
  default = "admin01!"
}
variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.0.0/16"
}
variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.10.0/24"
}
variable "image_publisher" {
  description = "name of the publisher of the image (az vm image list)"
  default     = "Canonical"
}

variable "image_offer" {
  description = "the name of the offer (az vm image list)"
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "image sku to apply (az vm image list)"
  default = {
    "image1" = "16.04-LTS"
    "image2" = "17.04-LTS"
  }
  type    = map
}

variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "hostname" {
  description = "VM name referenced also in storage-related names."
  default="tf"
}

variable "mapvar" {
    default =                         {
    "name" : "cpgip"
    duration = 958,
    count = 45
  }
  type = map  (string)
  description = "mapppp type"
}

variable "objectVar" {
 default = {
   name = "My Vm disk"
   //commment .......,
   env  = "Dev",
   isAvailable = true
 }
 type = object({
   name = string
   env  = string,
   isAvailable = bool
 })
 description = "Tags for the EC2 instance"
}
