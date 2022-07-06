#!/bin/dash
set -ex pipefail
mkdir artifacts
# TODO - check whether branch or tag
/usr/bin/curl -s --insecure --cert $TESTNET_CERT --key $TESTNET_KEY -X POST "https://sifter.a.dmz.appbattery.akadns.net/api/v2/queue/git" -H  "accept: application/json" -H  "X-DEBUG-FLAG: false" -H  "Content-Type: application/json" -d "{  \"project\": \"~bbodiya\",  \"repo\": \"gitlab-connectivity-test\",  \"branch\": \"${CI_COMMIT_REF_NAME}\"}" | jq -r '.["id"]' > artifacts/event_id.txt
cat artifacts/event_id.txt
