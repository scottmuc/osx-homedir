#!/usr/bin/env bash

set -e
set -o pipefail

[[ -z "${DEBUG}" ]] || set -x

CACHE_DIR="${HOME}/.config/deep-pockets"
SYNCED_JSON_DATA="${CACHE_DIR}/data.json"

main() {
  local sub_command
  sub_command="$1"
  case "$sub_command" in
    sync)
      sync
      ;;
    stats)
      display_stats
      ;;
    posts-by-tag)
      tag="$2"
      posts_by_tag "${tag}"
      ;;
    time-series-csv)
      time_series_csv
      ;;
    *)
      print_usage_and_exit
      ;;
  esac
}

print_usage_and_exit() {
  cat <<HELP
usage: $0 <command>

Deep understanding of getpocket.com data

Commands:
 - sync
     synchronize data locally with what's on getpocket.com

 - stats
     displays some stats of the whole dataset

 - posts-by-tag <tag>
     lists the urls of articles associated with a tag

 - time-series-csv
     lists all read articles over time
HELP

  exit 1
}

time_series_csv() {
  echo "time_read,time_to_read,work_related,tags"
  # if .time_to_read is null/empty, then choosing a time to read of 7
  # because that was the median value last time I calculated it
  read_articles \
    | jq -r "[.time_read,
               if (.time_to_read | length) == 0 then 7 else .time_to_read end,
               if (.tags | length) == 0 then false else (.tags.\"work-related\" != null) end,
               if (.tags | length) == 0 then \"untagged\" else (.tags | map(.tag) | join(\":\")) end
             ] | @csv"
}

posts_by_tag() {
  local tag="$1"
  tagged | jq -r ". | select(.tags[].tag == \"${tag}\") | .given_url"
}

work_related() {
  tagged | jq '. | select(.tags[].tag == "work-related")'
}

tagged() {
  all | jq "select(.tags != null)"
}

read_articles() {
  all | jq 'select(.is_article == "1") | select(.status = "1")'
}

all() {
  jq ".list[]" "${SYNCED_JSON_DATA}"
}


display_stats() {
  total_count=$(all | jq '.item_id' | wc -l)
  tagged_count=$(tagged | jq .item_id | wc -l)
  work_related_count=$(work_related | jq .item_id | wc -l)
  unread_count=$(all | jq -r 'select(.status == "0") | .item_id' | wc -l)
  reading_time=$(all | jq -r '.time_to_read' | paste -sd+ - | bc)
  work_related_reading_time=$(work_related | jq -r .time_to_read | paste -sd+ - | bc)
  tag_counts=$(tagged | jq -r .tags[].tag \
    | sort \
    | uniq -c \
    | sort -nr)

  cat <<STATS
article count              : ${total_count}
articles unread            : ${unread_count}
articles tagged            : ${tagged_count}
articles work related      : ${work_related_count}
reading time (work related): ${work_related_reading_time}m
reading time               : ${reading_time}m
tag counts                 :
${tag_counts}
STATS

}

sync() {
  local redirect_url consumer_key

  if [[ ! -d "${CACHE_DIR}" ]]; then
    mkdir -p "${CACHE_DIR}"
  fi

  # this jq query is an example of what makes the 1password CLI hard to work with
  # it is also coupling to my personal preference for a password manager
  consumer_key=$(op get item "deep-pockets" | \
    jq -r '.details.sections[] |select(.fields)| .fields[] | select(.t == "consumer-key") | .v')

  # stub webserver to handle browser redirect from getpocket.com
  redirect_url="http://localhost:1500/"

  request_code=$(curl \
    https://getpocket.com/v3/oauth/request 2>/dev/null \
    -X POST \
    -H "Content-Type: application/json; charset=UTF-8" \
    -H "X-Accept: application/json" \
    -d @- <<JSON |
{
  "consumer_key":"${consumer_key}",
  "redirect_uri":"${redirect_url}"
}
JSON
    jq -r .code)

  echo "Need to request a token, please open the following URL in your browser:

  https://getpocket.com/auth/authorize?request_token=${request_code}&redirect_uri=${redirect_url}
"

  nc -l localhost 1500 >/dev/null < <(echo -e "HTTP/1.1 200 OK\n\n $(date)")

  echo "Fetching data..."

  access_token=$(curl \
    https://getpocket.com/v3/oauth/authorize 2>/dev/null \
    -X POST \
    -H "Content-Type: application/json; charset=UTF-8" \
    -H "X-Accept: application/json" \
    -d @- <<JSON |
{
  "consumer_key":"${consumer_key}",
  "code":"${request_code}"
}
JSON
    jq -r .access_token)


  # interesting thing about `read` is that it doesn't exit 0 when successful
  # so that's why the trailing `true`
  read -r -d '' req_json <<FOO ||
{
  "consumer_key":"${consumer_key}",
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
    -o "${SYNCED_JSON_DATA}" \
    -X GET \
    -H "Content-Type: application/json" \
    -d "${req_json}"

  echo Data synchronized!
}

main "$@"
