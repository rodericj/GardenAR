firstID=`./scripts/getAnchors.sh |jq .[0].id|sed s/\"//g`
curl -X POST "localhost:8080/anchor/$firstID/metadata" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"text\" : \"first note\", \"type\" : \"url\"}"



