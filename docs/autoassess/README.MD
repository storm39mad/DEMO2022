
## PowerCLI

```bash

# Download the Microsoft repository GPG keys
wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb

# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb

# Update the list of products
sudo apt-get update

# Install PowerShell
sudo apt-get install -y powershell

# Start PowerShell
pwsh

# Install PowerCLI
Install-Module VMware.PowerCLI -Scope CurrentUser

# Set Execution policy
Set-ExecutionPolicy Unrestricted
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false
```

## Envs

```bash
export TF_VAR_vsphere_password='password'
export TF_VAR_nsxt_password='password'
```

## Run

```bash
terraform init
terraform validate
terraform plan
terraform apply
```