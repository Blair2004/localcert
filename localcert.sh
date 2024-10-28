#!/bin/bash

# Function to prompt the user for input with a default value
prompt() {
  local varname=$1
  local prompt_msg=$2
  local default_value=$3

  read -p "$prompt_msg [$default_value]: " input_value
  if [ -z "$input_value" ]; then
    input_value=$default_value
  fi
  eval "$varname='$input_value'"
}

# Prompt user for domain details
prompt CN "Enter the Common Name (CN) (e.g., yourdomain.local)" "yourdomain.local"
prompt SAN "Enter the Subject Alternative Name (SAN) (e.g., yourdomain.local)" "$CN"
prompt DAYS "Enter the number of days the certificate should be valid for" "365"
prompt KEY_LENGTH "Enter the key length" "2048"

# Generate file names for keys and certificates
private_key="${CN}.key"
csr_file="${CN}.csr"
cert_file="${CN}.crt"

# Create the OpenSSL config file
cat <<EOL > san.cnf
[ req ]
default_bits = $KEY_LENGTH
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
CN = $CN

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = $SAN
EOL

echo "OpenSSL configuration file 'san.cnf' created successfully!"

# Step 2: Generate the private key
echo "Generating private key..."
openssl genrsa -out $private_key $KEY_LENGTH
echo "Private key '$private_key' generated successfully."

# Step 3: Generate the CSR
echo "Generating Certificate Signing Request (CSR)..."
openssl req -new -key $private_key -out $csr_file -config san.cnf
echo "CSR '$csr_file' generated successfully."

# Step 4: Generate the self-signed certificate
echo "Generating self-signed certificate..."
openssl x509 -req -in $csr_file -signkey $private_key -out $cert_file -days $DAYS -extfile san.cnf -extensions req_ext
echo "Self-signed certificate '$cert_file' generated successfully."

# Final output
echo "SSL certificate generation complete!"
echo "Files created:"
echo "- Private Key: $private_key"
echo "- CSR: $csr_file"
echo "- Certificate: $cert_file"
echo "- OpenSSL Configuration: san.cnf"
