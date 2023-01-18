#!/bin/bash

source ./script.conf

source ./ic_oauth_token.sh $API_KEY
python oauth-token-parser.py
OAUTH_TOKEN=$(cat oauth-token.txt)

#List buckets
curl "https://${COS_ENDPOINT}/" \
	-H "Authorization: bearer ${OAUTH_TOKEN}" \
	-H "ibm-service-instance-id: ${CRN}" \
	> buckets.xml

python buckets-xml-parser.py buckets.xml

#List every object in every bucket in bucket-list.txt
for bucket in $(cat buckets.txt)
do
	curl "https://${COS_ENDPOINT}/$bucket" \
		-H "Authorization: bearer ${OAUTH_TOKEN}" \
		> $bucket-objects.xml
	#Parse desired objects and save to txt
	python object-xml-parser.py $bucket-objects.xml
	#List all objects in the bucket
	for object in $(cat $bucket-objects.txt)
	do
		REQUEST_BODY="<RestoreRequest><Days>1</Days><GlacierJobParameters><Tier>Accelerated</Tier></GlacierJobParameters></RestoreRequest>"
		MD5_HASH=$source ./hashmd5.sh ${REQUEST_BODY}
		curl -X "POST" "https://${COS_ENDPOINT}/${bucket}/${object}?restore" \
   		 	-H "Authorization: bearer ${OAUTH_TOKEN}" \
   		 	-H "Content-Type: text/plain" \
    		-H "Content-MD5: ${MD5_HASH}" \
    		-d "${REQUEST_BODY}" \
    		&>> response.txt
	done
done