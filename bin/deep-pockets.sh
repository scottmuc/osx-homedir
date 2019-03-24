#!/usr/bin/env bash

set -e
set -o pipefail

[[ -z "${DEBUG}" ]] || set -x

# this jq query is an example of what makes the 1password CLI hard to work with
CONSUMER_KEY=$(op get item "deep-pockets" | \
  jq -r '.details.sections[] |select(.fields)| .fields[] | select(.t == "consumer-key") | .v')

# stub webserver to handle browser redirect from getpocket.com
REDIRECT_URL="http://localhost:1500/"

request_code=$(curl \
  https://getpocket.com/v3/oauth/request 2>/dev/null \
  -X POST \
  -H "Content-Type: application/json; charset=UTF-8" \
  -H "X-Accept: application/json" \
  -d @- <<JSON |
{
  "consumer_key":"${CONSUMER_KEY}",
  "redirect_uri":"${REDIRECT_URL}"
}
JSON
  jq -r .code)

open "https://getpocket.com/auth/authorize?request_token=${request_code}&redirect_uri=${REDIRECT_URL}"

nc -l localhost 1500 >/dev/null < <(echo -e "HTTP/1.1 200 OK\n\n $(date)")

access_token=$(curl \
  https://getpocket.com/v3/oauth/authorize 2>/dev/null \
  -X POST \
  -H "Content-Type: application/json; charset=UTF-8" \
  -H "X-Accept: application/json" \
  -d @- <<JSON |
{
  "consumer_key":"${CONSUMER_KEY}",
  "code":"${request_code}"
}
JSON
  jq -r .access_token)


# interesting thing about `read` is that it doesn't exit 0 when successful
# so that's why the trailing `true`
read -r -d '' req_json <<FOO ||
{
  "consumer_key":"${CONSUMER_KEY}",
  "access_token":"${access_token}",
  "state":"all",
  "detailType":"complete"
}
FOO
true

# There is 1 single endpoint for retrieval of date from pocket. Everything
# you need to know is here: https://getpocket.com/developer/docs/v3/retrieve
curl \
  https://getpocket.com/v3/get 2>/dev/null \
  -X GET \
  -H "Content-Type: application/json" \
  -d "${req_json}"

