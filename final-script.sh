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
	python object-xml-parser.py $bucket-objects.xml $DATE
	
	#Restore all objects in the bucket
	for object in $(cat $bucket-objects.txt)
	do
		source ./restore-object.sh $OAUTH_TOKEN $COS_ENDPOINT \
		$bucket $object $DATE $DAYS $TIER \
		&>> response.txt
	done
done