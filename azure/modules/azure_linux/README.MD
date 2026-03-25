# Azure Linux Virtual Machine Module

## Description

This module automates the deployment of one or more Linux Virtual Machines within a specified Resource Group and Region. It is designed to work in a modular environment where networking infrastructure is managed separately.

The module handles:

    Public IP Addresses: Static allocation for each VM instance.

    Network Interfaces (NICs): Dynamic IP allocation with Public IP association.

    Network Security Groups (NSGs): Default rule allowing inbound SSH (TCP/22).

    NSG Association: Direct binding of security groups to individual NICs.

    Virtual Machines: Ubuntu 22.04 LTS instances with SSH-key authentication.

## Dependencies

    Terraform: v1.14.7+

    AzureRM Provider: >= 4.64.0

    Azure Subscription: Owner or Network Contributor permissions.

    On-Premises VPN Device: Required for site-to-site tunnel completion (BGP support recommended).