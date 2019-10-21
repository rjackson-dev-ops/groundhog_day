!/bin/bash

cp /home/ubuntu/.sdkman/candidates/java/8.0.212-amzn/jre/lib/security/cacerts .

ALIAS[0]=starfieldservicesrootcertificateauthority-g2
FILE[0]=starfield_services_root_certificateauthority_g2
ALIAS[1]=starfieldrootcertificateauthority-g2
FILE[1]=starfield_root_certificate_authority_g2
ALIAS[2]=amazonrootca4
FILE[2]=amazon_root_ca4
ALIAS[3]=amazonrootca3
FILE[3]=amazon_root_ca3
ALIAS[4]=amazonrootca2
FILE[4]=amazon_root_ca2
ALIAS[5]=amazonrootca1
FILE[5]=amazon_root_ca1

POSITION=0

for ALIAS in ${ALIAS[@]}; do

  NEXT_FILE=${FILE[${POSITION}]}

  keytool -export -keystore cacerts -alias ${ALIAS} -file ${NEXT_FILE}.cer -storepass changeit

  #convert to pem

  openssl x509 -inform der -in ${NEXT_FILE}.cer -outform PEM -out ${NEXT_FILE}.pem

  #upload to crossing
  crossing put -b vis-certs -f ${NEXT_FILE}.pem -k $inventory_store_key

  let POSITION=POSITION+1

done
