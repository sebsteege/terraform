# Azure Infrastructure Automation (Hub & Spoke)

This repository contains a Terraform-based framework for deploying a secure, automated Azure environment. It features a Hub VNet (containing shared services like Firewall and VPN Gateway) and multiple Spoke VNets for application workloads, following Microsoft’s best-practice network topology.

## Project Structure

The project is organized into functional modules to separate core connectivity from compute resources:

    azure_networking: Manages the VNet topology, CIDR boundaries, Peerings, Azure Firewall, and the S2S VPN Gateway (e.g., connection to a local pfSense/CVLab).

    azure_linux: Manages the deployment of Ubuntu 22.04 LTS instances, including Static Public IPs, Network Interfaces, and SSH-specific Security Groups.

    Root Directory: Coordinates the modules and manages the global state and variable assignments (terraform.tfvars).

## Architecture Logic

The architecture is designed for Network Automation. A key feature is the dynamic "handshake" between modules:

    The Networking module calculates the full Resource IDs for all subnets and exports them as a map.

    The Linux module accepts this map and uses it to automatically place VMs in the correct subnets without manual string manipulation.