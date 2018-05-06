for site in \
   10.228.81.175 

do
   url="${site}/index.html"
   echo "------------------"
   echo ""
   echo "Get URL - ${url}"
   curl url
   echo ""
   echo "------------------"
done