#!/bin/bash

OAUTH_ENDPOINT="https://iam.cloud.ibm.com/oidc/token"
API_KEY=$1

#Get oauth token
curl -X "POST" $OAUTH_ENDPOINT \
	-H 'Accept: application/json' \
	-H 'Content-Type: application/x-www-form-urlencoded' \
	--data-urlencode "apikey=$API_KEY" \
	--data-urlencode "response_type=cloud_iam" \
	--data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey"