#! /bin/bash

echo "------------------------------"
echo "| Jenkins image by taypo.com |"
echo "------------------------------"

# Prepare directories
mkdir -p $HOME/.ssh
chmod 700 $HOME/.ssh
touch $HOME/.ssh/known_hosts

# Generate public private key pair
if [ ! -f $HOME/.ssh/id_rsa.pub ]; then
    ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -q -N ""
    echo "=> Generated ssh keys"
    echo "=> Public key:"
    cat $HOME/.ssh/id_rsa.pub
fi

# Add known hosts
if [ -n "${KNOWN_HOSTS}" ]; then
    echo "=> Found known hosts"
    IFS=$'\n'
    arr=$(echo ${KNOWN_HOSTS} | tr "," "\n")
    for x in $arr
    do
        cat $HOME/.ssh/known_hosts | grep "$x" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "=> Adding host to .ssh/known_hosts: $x"
            ssh-keyscan $x >> $HOME/.ssh/known_hosts
        fi
    done
fi

# Run the original jenkins script
source /usr/local/bin/jenkins.sh
