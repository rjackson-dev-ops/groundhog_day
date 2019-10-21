#!/bin/bash

find . -type f -exec get_cert_domains.sh {} >> ~/domain_info.txt \;
