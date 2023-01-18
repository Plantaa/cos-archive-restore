#!/bin/bash

echo -n $1 | openssl dgst -md5 -binary | openssl enc -base64