#!/bin/bash
set -eo pipefail

#TESTNET_CERT=../gltest-testnet.crt
#TESTNET_KEY=../gltest-testnet.key
EVENT_ID=$(cat artifacts/event_id.txt)
echo "Event ID is: $EVENT_ID"

SOURCEJOB_CURL_CMD="curl -s --cert $TESTNET_CERT --key $TESTNET_KEY --insecure https://aci-results-api.default.hh.appbattery.shared.qa.akamai.com:5333/v1/events/${EVENT_ID}/sourceJobs"

echo -e "curl cmd is:\n$SOURCEJOB_CURL_CMD"

# Quit after waiting 10 minutes
QUITTING_TIME=60

SOURCE_JOB_ID=0
while [ $SOURCE_JOB_ID -lt $QUITTING_TIME 2> /dev/null ]
do
	sourceJobs=$(bash -c "$SOURCEJOB_CURL_CMD")
	#sourceJobs=$(cat responses/sourceJob_noevent.txt)
	#sourceJobs=$(cat responses/sourceJob_nojobyet.txt)
	#sourceJobs=$(cat responses/sourceJob.txt)
	echo $sourceJobs
	set +e
	noEvent=$( echo $sourceJobs | jq -r '.["message"]' 2> /dev/null || echo "HAS EVENT")
	jobId=$(echo $sourceJobs | jq -r '.[0]["jobId"]' 2> /dev/null)
	set -e
	if [[ $noEvent == "Couldn't find the event with id : '$EVENT_ID'." ]]; then
		echo "Event information not in aci-results yet."
		let "SOURCE_JOB_ID=SOURCE_JOB_ID+1"
		sleep 10
	elif [[ $jobId == "null" ]]; then
		echo "Event has been queued, but no job exists yet."
		let "SOURCE_JOB_ID=SOURCE_JOB_ID+1"
		sleep 10
	else
		SOURCE_JOB_ID=$jobId
	fi
done

if [[ $SOURCE_JOB_ID =~ ^-?[0-9]+$ ]]; then
	echo "ERROR - Job was never queued for event ${EVENT_ID}"
	exit 1
fi

echo "Source Job ID is: $SOURCE_JOB_ID"
echo "$SOURCE_JOB_ID" > artifacts/sourcejob_id.txt

# Begin Job Wait Section

JOBS_CURL_CMD="curl -s --cert $TESTNET_CERT --key $TESTNET_KEY --insecure https://aci-results-api.default.hh.appbattery.shared.qa.akamai.com:5333/v1/sourceJobs/$SOURCE_JOB_ID/jobs"

echo -e "curl cmd is:\n$JOBS_CURL_CMD"

# Quit after 10 minutes
COUNT=0
job=$(bash -c "$JOBS_CURL_CMD")
jobState=$(echo "$job" | jq -r '.[0].state')
JOB_ID=$(echo "$job" | jq -r '.[0].jobId')

echo "$JOB_ID" > artifacts/job_id.txt

while [[ ( "$jobState" != "DONE" ) && ( $COUNT < $QUITTING_TIME ) ]]
do
	echo "Job is not complete yet. Waiting..."
	sleep 10
	jobState=$(bash -c "$JOBS_CURL_CMD" | jq -r '.[0].state')
	let "COUNT=COUNT+1"
done

if [[ $jobState -eq "DONE" ]]; then
	echo "Job $JOB_ID is complete."
else
	echo "ERROR - Job $JOB_ID is still not complete."
	exit 1
fi

exit 0
