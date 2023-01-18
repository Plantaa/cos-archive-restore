#!/bin/bash

OAUTH_TOKEN=$1
COS_ENDPOINT=$2
BUCKET=$3
OBJECT=$4
DAYS=1
TIER="Accelerated"

REQUEST_BODY="<RestoreRequest><Days>$DAYS</Days><GlacierJobParameters><Tier>$TIER</Tier></GlacierJobParameters></RestoreRequest>"
MD5_HASH=$source ./hashmd5.sh ${REQUEST_BODY}
curl -X "POST" "https://${COS_ENDPOINT}/${BUCKET}/${OBJECT}?restore" \
 	-H "Authorization: bearer ${OAUTH_TOKEN}" \
	-H "Content-Type: text/plain" \
    -H "Content-MD5: ${MD5_HASH}" \
    -d "${REQUEST_BODY}" \
    &>> response.txt