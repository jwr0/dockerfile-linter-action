#!/bin/bash
set -e
set -o pipefail

if [[ ! -z "$TOKEN" ]]; then
	GITHUB_TOKEN=$TOKEN
fi

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

if [[ -z "$GITHUB_REPOSITORY" ]]; then
	echo "Set the GITHUB_REPOSITORY env variable."
	exit 1
fi

DOCKERFILE=${$GITHUB_WORKSPACE/$DOCKERFILE:$GITHUB_WORKSPACE/Dockerfile}
echo $DOCKERFILE
set +e
OUTPUT=$(/dockerfilelint/bin/dockerfilelint $DOCKERFILE)
SUCCESS=$?
echo $OUTPUT
set -e
# If there were errors as part of linting, post a comment. Else, do nothing.
if [ $SUCCESS -ne 0 ]; then
  PAYLOAD=$(echo '{}' | jq --arg body "$OUTPUT" '.body = $body')
  COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
  curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL" > /dev/null
fi
exit $SUCCESS
