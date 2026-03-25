# Azure Networking Hub-and-Spoke Module

A Terraform module for deploying a secure Azure Hub-and-Spoke network architecture featuring Azure Firewall and VPN Gateway connectivity.

## Description

This module automates the deployment of a hardened network topology in Azure. It establishes a Hub VNet containing an Azure Firewall (Premium) for centralized traffic inspection and a Virtual Network Gateway for site-to-site IPsec VPN connectivity to on-premises environments. The design includes automated User Defined Routes (UDR) to ensure all spoke-to-internet and spoke-to-on-prem traffic is proxied through the firewall, providing a central for network security and traffic logging.

## Dependencies

    Terraform: v1.14.7+

    AzureRM Provider: >= 4.64.0

    Azure Subscription: Owner or Network Contributor permissions.

    On-Premises VPN Device: Required for site-to-site tunnel completion (BGP support recommended).

## Dependencies

    Terraform: v1.14.7+

    AzureRM Provider: >= 4.64.0

    Azure Subscription: Owner or Network Contributor permissions.

    On-Premises VPN Device: Required for site-to-site tunnel completion (BGP support recommended).

    This project will require you to create a terraform.tfvars in the root of the directory where the values for variables will be defined.