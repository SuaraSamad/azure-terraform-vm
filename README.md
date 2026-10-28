# Azure Linux VM with Terraform

A simple Terraform setup that creates one small Ubuntu virtual machine in Azure and everything it needs so you can log in to it with SSH.

| Resource | Why it's needed |
| --- | --- |
| Resource group | Holds every resource below so they can be managed and deleted together |
| Virtual network + subnet | A private network for the VM to live in |
| Public IP | Lets you reach the VM from your computer |
| Network security group | Firewall that only lets SSH (port 22) in |
| Network interface | The VM's network card, joining it to the subnet and the public IP |
| Linux VM | Ubuntu 22.04, `Standard_B1s` (1 CPU, 1 GiB RAM), SSH-key login |

`Standard_B1s` costs roughly 1 US cent an hour plus the public IP and disk. Run `terraform destroy` when you're done.

## Files

| File | Purpose |
| --- | --- |
| `main.tf` | Provider setup and all resources |
| `variables.tf` | Inputs: names, region, VM size, admin user, SSH key path, allowed SSH source, tags |
| `outputs.tf` | Public IP and a ready-made SSH command |

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) 1.5 or newer
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli), signed in with `az login`
- An SSH key. If `~/.ssh/id_rsa.pub` doesn't exist, create one with `ssh-keygen -t rsa -b 4096`

## Usage

```bash
# 1. Sign in. Terraform uses the Azure CLI's active subscription.
az login

# 2. (Optional) edit variables.tf: region, VM name, size

# 3. Initialise, check and preview
terraform init
terraform validate
terraform plan

# 4. Create the VM (takes 1 to 3 minutes)
terraform apply

# 5. Inspect it
terraform output
terraform state list
az vm show -g rg-vm-demo -n vm-demo -d -o table
ssh azureuser@<public_ip_address>     # or copy the ssh_command output

# 6. Clean up
terraform destroy
```

The default region is `uksouth`, because East US had no capacity for `Standard_B1s`. If it isn't available in your region, set `vm_size` to `Standard_B2s` or pick another region.
