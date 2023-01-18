#!/bin/bash
API_KEY=$1
CRN=$2
COS_ENDPOINT=$3

curl "https://${COS_ENDPOINT}/" \
 -H "Authorization: bearer ${OAUTH_TOKEN}" \
 -H "ibm-service-instance-id: ${CRN}"