
## Step 1. Install FRR
```bash
sudo apt update
sudo apt install frr frr-pythontools -y
```

## Step 2. Enable necessary daemons
Edit `/etc/frr/daemons` and ensure:
```ini
zebra=yes
staticd=yes
```
Then restart the service:
```bash
sudo systemctl restart frr
```

## Step 3. Basic Configuration via vtysh
Launch vtysh:
```bash
sudo vtysh
```

Inside:
```vtysh
conf t
!
! Assign a virtual IP (optional)
interface eth0
 ip address 192.168.100.1/24
exit

! Add a static route for a specific network
ip route 10.10.10.0/24 10.0.2.2

! Add default route with high priority
ip route 0.0.0.0/0 10.0.2.2 metric 10
exit
write
```

## Why metric 10?
FRR by default uses metric 20. Your system (via DHCP) may already have a default route like:
```
default via 10.0.2.2 dev eth0 proto dhcp metric 100
```
By assigning `metric 10`, FRR's route takes precedence without deleting the system one.

## Step 4. Verify route
```bash
ip route
```
Should show:
```
default via 10.0.2.2 dev eth0 proto static metric 10
10.10.10.0/24 via 10.0.2.2 dev eth0 proto static metric 20
```

You can also test:
```bash
ip route get 10.10.10.1
```

## Summary:
- FRR installed and enabled
- Static and default routes added via `vtysh`
- Metric set to 10 to override system DHCP default
- Persistent config saved to `/etc/frr/frr.conf`

   Screenshots included: `ip route`, `vtysh` commands.
