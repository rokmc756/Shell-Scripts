
# Ops Manager
# sshpass -p "changeme" ssh -o StrictHostKeyChecking=no ubuntu@192.168.0.202
sshpass -p "changeme" ssh -o StrictHostKeyChecking=no ubuntu@192.168.0.3

# sshpass -p "changeme" ssh -o StrictHostKeyChecking=no ubuntu@192.168.0.2

# Bosh Director VM
# ssh -i /Users/moonja/.ssh/bbr.pem bbr@192.168.0.2

# https://docs.vmware.com/en/VMware-Tanzu-Operations-Manager/3.0/vmware-tanzu-ops-manager/install-ssh-login.html
# sed -ie 's/\\n/\n/g' ./bbr.pem

