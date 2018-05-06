#!/bin/bash

curlUrl() {
   echo "------------------"
   echo ""
   echo "Get URL - ${url}"
   curl -s $url
   echo ""
   echo "------------------"

}


for ipAddress in "$@"
do

		echo
		echo The next Ip Address is: $ipAddress
		echo

		echo  App URLs
		echo


		url="call-center-services: http://${ipAddress}:9001/callcenterservices/index.html"
		curlUrl

		url="property-event-listener: http://${ipAddress}:9002/propertyeventlistener/index.html"
		curlUrl
done




