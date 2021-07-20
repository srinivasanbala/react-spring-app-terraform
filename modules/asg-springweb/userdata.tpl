#cloud-config

hostname: ${hostname}
fqdn: ${hostname}

# Enable root account.
disable_root: false

locale: en_US.utf8
timezone: UTC

packages:
 - maven
 - epel-release
 - git
 - lvm2
 - screen
 - telnet
 - wget

bootcmd:
 - /bin/sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

runcmd:
 - "/usr/local/bin/bootstrap.sh  >> /tmp/bootstrap.log"

write_files:
 - path: "/usr/local/bin/bootstrap.sh"
   permissions: "0777"
   owner: "root:root"
   content: |
     #!/bin/bash
     set -x

     # Update hostname with instance-id
     instanceID=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id | /bin/sed -e 's/i-//'`
     newhostname=`/bin/hostname -s | /bin/sed -e "s/AS/$${instanceID}/"`
     /bin/hostname $${newhostname}
     /bin/sed -i'' -e "s/HOSTNAME=.*/HOSTNAME=$${newhostname}/" /etc/sysconfig/network

     # Disable iptables.
     /sbin/service iptables stop
     /sbin/chkconfig iptables off

     # Update hosts in order to support 'facter fqdn'.
     ipaddr=`/sbin/ip addr list eth0 | /bin/sed -ne 's!^.*inet \([^/]*\).*$!\1!p'`
     echo "$${ipaddr} $${newhostname} $${newhostname}" >> /etc/hosts

     # Configure motd.
     (
     echo
     echo "Hostname:  $${newhostname}"
     echo
     ) > /etc/motd

     # Configure prompt.
     cat > /etc/profile.d/poc-prompt.sh <<'eof'
     export PS1='[\u@\h/\l:\w]\$ '
     eof
     chmod 755 /etc/profile.d/poc-prompt.sh

     # download git repo
     mkdir /usr/local/poc
     cd /usr/local/poc ; curl -u <userid>:<password> -o react.jar https://pocnexus.com/nexus3/repository/poc-devops/react/<version>/react-<version>.jar
     nohup java -jar /usr/local/poc/react.jar &
