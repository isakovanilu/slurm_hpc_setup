# SLURM HPC Cluster Setup

This project automates the setup of a SLURM High-Performance Computing (HPC) cluster using a combination of [Vagrant](https://www.vagrantup.com/docs), [Terraform](https://www.terraform.io/docs), and [Ansible](https://docs.ansible.com/). The cluster consists of a controller node and multiple compute nodes.

## Files to Include in GitHub

### Required Files
- `Vagrantfile` - VM configuration
- `slurm_terraform.tf` - Terraform configuration
- `ansible/` directory with:
  - `inventory.ini` - Ansible inventory
  - `slurm.yml` - Ansible playbook
- `slurm.conf` - Base SLURM configuration
- `slurm_updated.conf` - Updated SLURM configuration
- `hello.slurm` - Example job script
- `README.md` - Project documentation
- `.gitignore` - Git ignore rules

### Files to Exclude
- `munge.key` - Sensitive authentication key
- `*.tfstate` and `*.tfstate.backup` - Terraform state files
- `.terraform/` directory - Terraform cache
- `.vagrant/` directory - Vagrant cache
- SSH keys and certificates
- Log files
- System files (`.DS_Store`, `Thumbs.db`)

### Sensitive Information
Before pushing to GitHub:
1. Generate a new `munge.key` for your deployment
2. Update IP addresses in configuration files if needed
3. Remove any hardcoded credentials
4. Use environment variables for sensitive data

## Project Structure

```
.
├── ansible/                 # Ansible playbooks and inventory
│   ├── inventory.ini       # Ansible inventory file
│   └── slurm.yml          # Ansible playbook for SLURM setup
├── terraform/              # Terraform configuration files
├── Vagrantfile            # Vagrant configuration for VM setup
├── slurm_terraform.tf     # Terraform configuration for SLURM
├── slurm.conf             # SLURM configuration file
├── slurm_updated.conf     # Updated SLURM configuration
├── munge.key              # MUNGE authentication key
└── hello.slurm            # Example SLURM job script
```

## Prerequisites

- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Terraform](https://www.terraform.io/downloads)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- SSH key pair
- Ubuntu-based system (tested with Ubuntu 20.04)

## Cluster Architecture

The cluster consists of:
- 1 Controller node (10.0.0.1)
- 3 Compute nodes (10.0.0.2, 10.0.0.3, 10.0.0.4)

## SLURM Configuration Details

The cluster is configured with the following settings:

### Basic Configuration
- Cluster Name: slurmcluster
- Control Machine: controller
- Authentication: [MUNGE](https://dun.github.io/munge/)
- Scheduler: Backfill
- Resource Selection: Consumable TRES (Trackable Resources)

### Node Configuration
- Each compute node has:
  - 1 CPU core
  - Default state: UNKNOWN
  - Node addresses configured in slurm_updated.conf

### Partition Configuration
- Partition Name: debug
- Default Partition: Yes
- Maximum Time: INFINITE
- State: UP
- Includes all compute nodes

### Logging and State
- State Save Location: /var/spool/slurmctld
- Slurmd Spool Directory: /var/spool/slurmd
- Log Files:
  - Controller: /var/log/slurm/slurmctld.log
  - Compute Nodes: /var/log/slurm/slurmd.log

## Setup Instructions

1. **Virtual Machine Setup**
   ```bash
   vagrant up
   ```
   This will create the virtual machines using the configuration in `Vagrantfile`.

2. **Terraform Deployment**
   ```bash
   terraform init
   terraform apply
   ```
   This will deploy the SLURM configuration to all nodes.

3. **Ansible Configuration**
   ```bash
   ansible-playbook -i ansible/inventory.ini ansible/slurm.yml
   ```
   This will:
   - Install SLURM dependencies (slurm-wlm, munge, nfs-common)
   - Configure the controller node with slurmctld service
   - Configure compute nodes with slurmd service
   - Enable and start all necessary services

## Configuration Files

- `slurm.conf`: Main SLURM configuration file
  - Basic cluster configuration
  - Node definitions
  - Partition setup
- `slurm_updated.conf`: Updated SLURM configuration
  - Updated node definitions with IP addresses
  - Multiple compute node support
- `munge.key`: Authentication key for SLURM nodes
- `slurm_terraform.tf`: Terraform configuration for SLURM deployment
- `ansible/slurm.yml`: Ansible playbook for SLURM setup
  - Installs required packages
  - Configures controller and compute nodes
  - Manages SLURM services

## Example Job Submission

The project includes a sample SLURM job script (`hello.slurm`):
```bash
#!/bin/bash
#SBATCH --job-name=hello-test
#SBATCH --output=/tmp/hello-%j.out
#SBATCH --error=/tmp/hello-%j.err

echo "Hello from SLURM node!"
hostname
```

To submit this job:
```bash
sbatch hello.slurm
```

To check job status:
```bash
squeue
```

For more information about SLURM job submission, see the [SLURM Documentation](https://slurm.schedmd.com/documentation.html).

## Security Notes

- The MUNGE key is used for authentication between nodes
- SSH keys are used for secure communication
- All nodes are configured with proper permissions and security settings
- NFS is configured for shared storage between nodes

## Maintenance

- To restart SLURM services:
  - Controller: `sudo systemctl restart slurmctld`
  - Compute nodes: `sudo systemctl restart slurmd`
- To check service status:
  - Controller: `sudo systemctl status slurmctld`
  - Compute nodes: `sudo systemctl status slurmd`
- To check logs:
  - Controller: `tail -f /var/log/slurm/slurmctld.log`
  - Compute nodes: `tail -f /var/log/slurm/slurmd.log`

## Troubleshooting

1. Check SLURM status:
   ```bash
   sinfo
   ```

2. View job queue:
   ```bash
   squeue
   ```

3. Check node status:
   ```bash
   scontrol show nodes
   ```

4. View job output:
   ```bash
   cat /tmp/hello-<job_id>.out
   ```

5. View job errors:
   ```bash
   cat /tmp/hello-<job_id>.err
   ```

6. Check MUNGE authentication:
   ```bash
   munge -n | unmunge
   ```

7. Verify SLURM configuration:
   ```bash
   scontrol show config
   ```

For more troubleshooting information, refer to:
- [SLURM Troubleshooting Guide](https://slurm.schedmd.com/troubleshoot.html)
- [MUNGE Documentation](https://dun.github.io/munge/)
- [Ansible Troubleshooting](https://docs.ansible.com/ansible/latest/user_guide/playbooks_troubleshooting.html)

## Additional Resources

- [SLURM Official Documentation](https://slurm.schedmd.com/documentation.html)
- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Ansible Documentation](https://docs.ansible.com/)
- [VirtualBox Documentation](https://www.virtualbox.org/manual/)

## License

[Add your license information here] 