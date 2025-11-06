#!/usr/bin/env bash
# file: hit-loop.sh
# Usage: ./hit-loop.sh [URL] [TOTAL] [DELAY_MS]
# Example: ./hit-loop.sh http://172.17.166.2:82/ 100 10

URL="${1:-http://localhost:port/}"
TOTAL="${2:-0}"      # 0 = infinite
DELAY_MS="${3:-10}"  # milliseconds between requests (small -> higher rate)

count=0
start_ts=$(date +%s.%N)

while true; do
  # Fire and forget to keep loop fast; capture HTTP code and time
  curl -s -o /dev/null -w "%{http_code} %{time_total}\n" "$URL" &
  ((count++))
  if [[ $TOTAL -ne 0 && $count -ge $TOTAL ]]; then
    wait
    break
  fi
  # delay in milliseconds
  sleep_time=$(awk "BEGIN {print $DELAY_MS/1000}")
  sleep "$sleep_time"
done

wait
end_ts=$(date +%s.%N)
elapsed=$(awk "BEGIN {print $end_ts - $start_ts}")
echo "Sent $count requests in ${elapsed}s
