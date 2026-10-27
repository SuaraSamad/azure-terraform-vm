# Azure Linux VM with Terraform

Terraform that creates an Ubuntu 22.04 virtual machine in its own resource group, with everything it needs to be reachable:

| Resource | Why it's needed |
| --- | --- |
| Resource group | Holds every resource below so they can be managed and deleted together |
| Virtual network + subnet | A private network for the VM to live in |
| Public IP | Lets you reach the VM from the internet |
| Network security group | Firewall: allows SSH (22) and HTTP (80), blocks all other inbound traffic |
| Network interface | The VM's network card, joining it to the subnet and the public IP |
| Linux VM | Ubuntu 22.04, `Standard_B1s`, SSH-key login only, nginx installed on first boot |

`Standard_B1s` costs roughly 1 US cent an hour plus the public IP and disk. Run `terraform destroy` when you're done.

## Files

| File | Purpose |
| --- | --- |
| `main.tf` | Provider setup and all resources |
| `variables.tf` | Inputs: names, region, VM size, admin user, SSH key path, allowed SSH source, tags |
| `outputs.tf` | Public IP, ready-made SSH command and website URL |
| `scripts/cloud-init.yaml` | First-boot script that installs nginx and writes a test page |

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) 1.5 or newer
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli), signed in with `az login`
- An SSH key pair. If `~/.ssh/id_rsa.pub` doesn't exist, create one with `ssh-keygen -t rsa -b 4096`

## Usage

```bash
# 1. Sign in. Terraform uses the Azure CLI's active subscription.
az login

# 2. (Optional) edit variables.tf: region, VM name, size, allowed_ssh_source

# 3. Initialise, check and preview
terraform init
terraform fmt
terraform validate
terraform plan

# 4. Create the VM (takes 1 to 3 minutes)
terraform apply

# 5. Inspect and use it
terraform output
terraform state list
az vm show -g rg-vm-demo -n vm-demo -d -o table
ssh azureuser@<public_ip_address>     # or copy the ssh_command output
# open the website_url output in a browser to see the nginx page

# 6. Clean up
terraform destroy
```

To allow SSH only from your own IP address:

```bash
terraform apply -var="allowed_ssh_source=$(curl -s https://api.ipify.org)/32"
```

If `Standard_B1s` isn't available in your region, set `vm_size` to `Standard_B2s` or pick another region.
