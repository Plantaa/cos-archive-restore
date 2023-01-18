#!/bin/bash

OAUTH_TOKEN=$1
COS_ENDPOINT=$2
BUCKET=$3

curl "https://${COS_ENDPOINT}/$BUCKET" \
	-H "Authorization: bearer ${OAUTH_TOKEN}"