#!/bin/bash

source ./script.conf

#Retrieve the oauth token
source ./ic_oauth_token.sh $API_KEY > oauth-token.json
python3 oauth-token-parser.py oauth-token.json
OAUTH_TOKEN=$(cat oauth-token.txt)

#List buckets
source ./list-buckets.sh $API_KEY $CRN $COS_ENDPOINT > bucket-list.xml
python3 buckets-xml-parser.py bucket-list.xml

#Iterate every bucket in buckets.txt
for bucket in $(cat buckets.txt)
do
	#List all objects from a bucket
	source ./list-objects.sh $OAUTH_TOKEN $COS_ENDPOINT $bucket \
	> $bucket-objects.xml

	#Parse desired objects and save to txt
	python3 object-xml-parser.py $bucket-objects.xml $DATE
	
	#Restore all desired objects in the bucket
	for object in $(cat $bucket-objects.txt)
	do
		source ./restore-object.sh $OAUTH_TOKEN $COS_ENDPOINT \
		$bucket $object $DAYS $TIER \
		&>> response.txt
	done
done
