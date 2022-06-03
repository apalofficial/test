#!/bin/sh
set -eo pipefail
/usr/bin/curl --insecure --cert $TESTNET_CERT --key $TESTNET_KEY -X POST "https://sifter.default.hh.appbattery.shared.qa.akamai.com:4333/api/v2/queue/git" -H  "accept: application/json" -H  "X-DEBUG-FLAG: false" -H  "Content-Type: application/json" -d "{  \"project\": \"~bbodiya\",  \"repo\": \"gitlab-connectivity-test\",  \"branch\": \"main\"}"
