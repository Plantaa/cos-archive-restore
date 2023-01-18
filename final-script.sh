#!/bin/bash

source ./script.conf
source ./ic_oauth_token.sh $API_KEY > oauth-token.json
python oauth-token-parser.py oauth-token.json
OAUTH_TOKEN=$(cat oauth-token.txt)

#List buckets
source ./list-buckets.sh $API_KEY $CRN $COS_ENDPOINT > bucket-list.xml

python buckets-xml-parser.py bucket-list.xml

#List every object in every bucket in bucket-list.txt
for bucket in $(cat buckets.txt)
do
	source ./list-objects.sh $OAUTH_TOKEN $COS_ENDPOINT $bucket \
	> $bucket-objects.xml

	#Parse desired objects and save to txt
	python object-xml-parser.py $bucket-objects.xml
	
	#Restore all objects in the bucket
	for object in $(cat $bucket-objects.txt)
	do
		source ./restore-object.sh $OAUTH_TOKEN $COS_ENDPOINT $bucket $object \
		&>>response.txt
		# REQUEST_BODY="<RestoreRequest><Days>1</Days><GlacierJobParameters><Tier>Accelerated</Tier></GlacierJobParameters></RestoreRequest>"
		# MD5_HASH=$source ./hashmd5.sh ${REQUEST_BODY}
		# curl -X "POST" "https://${COS_ENDPOINT}/${bucket}/${object}?restore" \
   		#  	-H "Authorization: bearer ${OAUTH_TOKEN}" \
   		#  	-H "Content-Type: text/plain" \
    	# 	-H "Content-MD5: ${MD5_HASH}" \
    	# 	-d "${REQUEST_BODY}" \
    	# 	&>> response.txt
	done
done