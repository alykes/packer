### Basic commands

`packer fmt template.pkr.hcl`

`packer validate template.pkr.hcl`

`packer build template.pkr.hcl`

`packer build -debug`

`packer build -var`

`packer build -only`

`packer build -on-error`


Provisioners fall into one of three categories
- Configuration Management (Ansible, Puppet, Chef, etc)  
- Script (bash, cmd)  
- File (Assets, config files, full directories, download or upload)  


## File Provisioners
Move to /tmp and then move into the other area, you can set permissions with a file provisioner


## Script Provisioners

- Local Shell (Run script on a local machine, not on the image you are building)
- Remote Shell (Run script on the image you are builing)
- Powershell (Powershell scripts)
- Windows Shell (Batch script)
- Windows Restart (Here to reboot a windows machine during a build)
