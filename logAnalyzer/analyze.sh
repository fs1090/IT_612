#!/bin/bash

LOG_FILE="server.log"

echo "=== Log Analysis Report ==="
echo ""

echo "--- Line Counts ---"
echo "Total lines: $(wc -l < "$LOG_FILE")"
echo "Error lines: $(grep "ERROR" "$LOG_FILE" | wc -l)"
echo "Warning lines: $(grep "WARN" "$LOG_FILE" | wc -l)"
echo ""

echo "--- Unique Error Messages ---"
grep "ERROR" "$LOG_FILE" \
  | awk '{for(i=4;i<=NF;i++) printf "%s ", $i; print ""}' \
  | sort | uniq
echo ""

echo "--- Top Endpoints ---"
grep -E "GET|POST" "$LOG_FILE" \
  | awk '{print $5, $6}' \
  | sort | uniq -c | sort -rn
echo ""

echo "--- User Logins ---"
grep "session created for user=" "$LOG_FILE" \
  | grep -o 'user=[a-zA-Z0-9]*' \
  | cut -d= -f2 \
  | sort | uniq -c | sort -rn
echo ""

echo "Report generated: $(date)"