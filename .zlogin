# Import ssh/gpg keys on login

which keychain > /dev/null 2>&1 && eval `keychain --clear --ignore-missing --quiet --nogui --eval id_dsa id_rsa`

# Set exit status code to 0
:

