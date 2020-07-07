firstID=`curl -X GET "localhost:8080/world"|jq .[0].id|sed s/\"//g`

echo "got the first id"
echo $firstID
curl -X POST "localhost:8080/world/$firstID/anchor" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"title\" : \"first anchor\"}"
