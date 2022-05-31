#!/bin/sh
set -eo pipefail
curl --insecure --cert $TESTNET_CERT --key $TESTNET_KEY -X POST "https://sifter.default.abattery.appbattery.nss1.tn.akamai.com:4433/api/v2/queue/git" -H  "accept: application/json" -H  "X-DEBUG-FLAG: false" -H  "Content-Type: application/json" -d "{  \"project\": \"~bbodiya\",  \"repo\": \"gitlab-connectivity-test\",  \"branch\": \"main\"}"
