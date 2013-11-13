#!/bin/sh

# This script will create a VirtualBox Ubuntu 64 bit Instance

read -p "Enter full path to Ubuntu ISO: " isopath
read -p "Enter base path location to create VM: " basepath
read -p "Enter VirtualBox Instance Name: " instancename
read -p "Enter Host Path (source dir) to Link to VM: " sourcepath

[ ! -d $basepath ] && echo "directory not found" && exit 1

cd $basepath

# create vm instance
VBoxManage createvm --name "$instancename" --register --ostype "Ubuntu_64" --basefolder $basepath

# general modifications to vm instance
VBoxManage modifyvm "$instancename" --memory 512 --vram 16 --acpi on --boot1 dvd --cpus 2 --accelerate3d off --nic1 bridged --bridgeadapter1 eth0 --clipboard bidirectional --monitorcount 1 --usb on

cd $instancename

# create vm virtual hard drive
VBoxManage createhd --filename "./$instancename.vdi" --size 8000
VBoxManage storagectl "$instancename" --name "SATA Controller" --add sata
VBoxManage storagectl "$instancename" --name "IDE Controller" --add ide
VBoxManage storageattach "$instancename" --storagectl "SATA Controller"  --port 0 --device 0 --type hdd --medium "./$instancename.vdi"

# attached ubuntu dvd image
VBoxManage storageattach "$instancename" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$isopath"

# shared folder
VBoxManage sharedfolder add "$instancename" --name "Source" --hostpath "$sourcepath" --automount

# allow symbolic links
VBoxManage setextradata "$instancename" VBoxInternal2/SharedFoldersEnableSymlinksCreate/Source 1

#Start VM
VBoxManage startvm "$instancename"