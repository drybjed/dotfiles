# Import ssh/gpg keys on login

[ `which keychain` ] && eval `keychain --clear --ignore-missing --quiet --eval id_dsa id_rsa`

