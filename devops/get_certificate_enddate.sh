#!/bin/bash

pem=$1

# Onf Mac GFE
# printf '%s' \
#         "$(date -jf "%b %e %H:%M:%S %Y %Z" "$(openssl x509 -enddate -noout -in "$pem"|cut -d= -f 2)" +"%Y_%m_%d")"

# on Linux Bastion
printf '%s' \
        "$(date --date="$(openssl x509 -in "$pem" -noout -enddate | cut -d= -f 2)" --iso-8601)"
