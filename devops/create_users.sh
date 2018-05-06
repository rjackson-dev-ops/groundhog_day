#!/bin/bash

USER[0]='user1'
KEY[0]='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzmI7NMopBUPDeCCayBnXc17B6fos3yE3pvp2zl3qEioMtYBBtkLBYJOrq3T2lYrodfdafjdafjsj/kBzyVNqMl9ersB5jIF9hrOSd7jMDv43qeVX7UkmQ0uL+irX1YfPrRjC114CamzRUp6ydWpEaHs4GO2NJu8yyGMgZAJSoFahoUCinTJxDLnvGtvErWm3PnQ7EWlu0NQIro0+O8v/He/nr4hm+AtA9a6WB5cmci7dJs3sGjyXI2q3dgktbzU+rhSg8+Li+8/0hSr3E2HEs4AlCVP3rnCytZaX1s53pwbT+hBtI+ImSkyL64X/arvtc0E3W/CCe8PTZtiqkQgZV5BGY9LreZ+AR icedfsfdd1138@Xnet-OSX-2.local'

USER[1]='user2'
KEY[1]='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvB8P8L7zbzPYbSznUYxtwKwLuHw3iBXi88q0B/dffafsdfsfTuRp8Ps1IWblnuqOh7KTiKRNr1w5cfc74sM5kobLB5YogBYK4I/PMTba0PZuT66PVRLUYZYC34tI2Xp7oviiQ2v7mbtPfQHwHOWrFnwWEGjjNA2/lRzFJlzOiiAKNlvL4dWIlhkSfzwC34G5dqARdGwIdWQZHkyJ8Z2cYZD1cgvt8eCSU74YZjYeglCqtnkEkV8YJY/OUdnrjlYTcxXVjkZcL03wpnrvgR2/7DYW213QPDdS30+CxkrmL261BD9DQH+rItmKvwX12hsNbR+U3EwCxI08rQqK3+EVkDw7G2pnhGJ nnelson@Bdafdasfates-MacBook-Pro-2.local'

#### Create users and add to wheel group
POSITION=0
for USER in ${USER[@]}; do
    echo "Creating user: ${USER}"
    echo "Public Keys: ${KEY[${POSITION}]}"

    # Create User
    useradd -m -d /home/${USER} -c '${USER}' -s /bin/bash ${USER}
    # Add to wheel group
    /usr/sbin/usermod -a -G wheel ${USER}

    # Create ~/.ssh and add public key to authorized keys, fix perms
    mkdir -p /home/${USER}/.ssh
    chmod 755 /home/${USER}/.ssh
    echo ${KEY[${POSITION}]} >> /home/${USER}/.ssh/authorized_keys
    chmod 600 /home/${USER}/.ssh/authorized_keys
    chown -R ${USER}:${USER} /home/${USER}/.ssh

    let POSITION=POSITION+1

    echo "User created: ${USER}"
    echo ""

done

if [[ ${EXIT_STATUS} -eq 0 ]]; then
  exit 0
else
  exit 1
fi
