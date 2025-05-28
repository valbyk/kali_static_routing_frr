# README — Static Routing with FRR on Kali Linux

This project documents the setup of static routing using FRRouting (FRR) on Kali Linux as part of a practical networking task. It includes full CLI steps, explanations, and configuration logic for replicating a routing lab.

## Objective
- Install and configure FRR
- Set up a static route for a test subnet
- Define a default route with higher priority than the system DHCP default
- Ensure configuration persists after reboot

## Tools Used
- Kali Linux (VirtualBox/NAT setup)
- FRRouting (v10.3)
- vtysh CLI interface

## Setup Summary

### 1. Install FRR
```bash
sudo apt update
sudo apt install frr frr-pythontools -y
```

### 2. Enable Daemons
Edit `/etc/frr/daemons`:
```
zebra=yes
staticd=yes
```
Restart service:
```bash
sudo systemctl restart frr
```

### 3. Configure Routing via vtysh
```bash
sudo vtysh
```
```vtysh
conf t
interface eth0
 ip address 192.168.100.1/24
exit
ip route 10.10.10.0/24 10.0.2.2
ip route 0.0.0.0/0 10.0.2.2 metric 10
exit
write
```

### 4. Explanation
- `10.0.2.15`: local IP in NAT mode
- `10.0.2.2`: NAT gateway (VirtualBox default)
- `metric 10`: ensures FRR's default route overrides `proto dhcp` route with metric 100

### 5. Validate
```bash
ip route
```
Expected:
```
default via 10.0.2.2 dev eth0 proto static metric 10
10.10.10.0/24 via 10.0.2.2 dev eth0 proto static metric 20
```

## Files
- `/etc/frr/frr.conf` (auto-saved by `write` in vtysh)
- Screenshot proof of `ip route`, `vtysh` output

## Result
Static routing is configured and persistent across reboots. FRR now manages routing logic on the host, and the setup is suitable for demonstration, testing or education.
