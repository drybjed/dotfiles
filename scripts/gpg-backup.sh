#!/bin/bash

# Use this script in a encrypted volume to create backup copy of your current
# ~/.gnupg/ keyring, and separate copy of the same keyring with master secret key
# stripped from secret keys, which you can later import back.

# Full backup will be in:			gnupg_archive_*/full/
# Secret keys without master will be in:	gnupg_archive_*/nomaster/
# Public keys will be in:			gnupg_archive_*/public/


# List of GPG secret keys to backup
gpg_secret_keys=( $(gpg --with-colons --list-secret-keys | awk -F: '$1 == "sec" {print $5;}') )

# List of GPG public keys to backup
gpg_public_keys=( $(gpg --with-colons --list-keys | awk -F: '$1 == "pub" {print $5;}') )

archive_dir="./gnupg_archive_$(date +%Y%m%d%H%M%S)"
full_dir="${archive_dir}/full"
nomaster_dir="${archive_dir}/nomaster"
public_dir="${archive_dir}/public"

mkdir -p ${full_dir}
mkdir -p ${nomaster_dir}
mkdir -p ${public_dir}

# Copy GnuPG configuration
cp ~/.gnupg/gpg.conf ${full_dir}/gpg.conf
cp ~/.gnupg/gpg.conf ${nomaster_dir}/gpg.conf
cp ~/.gnupg/gpg.conf ${public_dir}/gpg.conf

# Write some information about secret keys
for key in "${gpg_secret_keys[@]}" ; do
	gpg --list-sigs --fingerprint ${key} > ${full_dir}/info_${key}.txt
	gpg --list-sigs --fingerprint ${key} > ${nomaster_dir}/info_${key}.txt
done

# Write some information about public keys
for key in "${gpg_public_keys[@]}" ; do
	gpg --list-sigs --fingerprint ${key} > ${public_dir}/info_${key}.txt
done

# Export secret keys to full backup
for key in "${gpg_secret_keys[@]}" ; do
	gpg --armor --export ${key} > ${full_dir}/key_public_${key}.asc
	gpg --armor --export-secret-keys ${key} > ${full_dir}/key_secret_${key}.asc
done

# Export secret keys without master key
for key in "${gpg_secret_keys[@]}" ; do
	gpg --armor --export ${key} > ${nomaster_dir}/key_public_${key}.asc
	gpg --armor --export-secret-subkeys ${key} > ${nomaster_dir}/key_secret_${key}.asc
done

# Export public keys
for key in "${gpg_public_keys[@]}" ; do
	gpg --armor --export ${key} > ${public_dir}/key_public_${key}.asc
done

# Export the owner trust database (not for public)
gpg --armor --export-ownertrust > ${full_dir}/trustdb_${USER}.txt
gpg --armor --export-ownertrust > ${nomaster_dir}/trustdb_${USER}.txt

