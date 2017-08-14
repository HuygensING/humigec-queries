#!/bin/bash

firstNextCursor=$(curl -v -H "Accept: application/json" http://localhost:8080/v5/DUMMY/vocopv/graphql/?query=%7Bvocopv_PlaatsList%28count%3A10000%29%20%7B%0D%0A%20skos_exactMatch%7Buri%7D%20skos_prefLabel%7Bvalue%7D%7D%7D | jq '.data.vocopv_PlaatsList | .[0]  | .nextCursor')

curl -v -H "Accept: application/json" http://localhost:8080/v5/DUMMY/vocopv/graphql/?query=%7Bvocopv_PlaatsList%28count%3A10000%29%20%7B%0D%0A%20skos_exactMatch%7Buri%7D%20skos_prefLabel%7Bvalue%7D%7D%7D | jq '.data.vocopv_PlaatsList | .[1:]' > places1.json 

urlEncodedCursor=$(urlencode "$firstNextCursor")

echo $urlEncodedCursor

nextCursor=$urlEncodedCursor

index=2;

while [ "$nextCursor" = "null" ]
#for i in `seq 1 3`;
do
    echo "Iteration: ${index}"
    curl -v -H "Accept: application/json" http://localhost:8080/v5/DUMMY/vocopv/graphql/?query=%7Bvocopv_PlaatsList%28count%3A10000%2C%20cursor%3A${nextCursor}%29%20%7B%0D%0A%20skos_exactMatch%7Buri%7D%20skos_prefLabel%7Bvalue%7D%7D%7D | jq '.data.vocopv_PlaatsList | .[1:]' > places${index}.json
    nextCursor=$(curl -v -H "Accept: application/json" http://localhost:8080/v5/DUMMY/vocopv/graphql/?query=%7Bvocopv_PlaatsList%28count%3A10000%2C%20cursor%3A${nextCursor}%29%20%7B%0D%0A%20skos_exactMatch%7Buri%7D%20skos_prefLabel%7Bvalue%7D%7D%7D | jq '.data.vocopv_PlaatsList | .[0]  | .nextCursor')
    index=$((index+1))
done



#nextCursor=$(curl -v -H "Accept: application/json" http://localhost:8080/v5/DUMMY/vocopv/graphql/?query=%7Bvocopv_PlaatsList%28count%3A10000%29%20%7B%0D%0A%20skos_exactMatch%7Buri%7D%20skos_prefLabel%7Bvalue%7D%7D%7D | jq '.data.vocopv_PlaatsList | .[0]  | .nextCursor')



