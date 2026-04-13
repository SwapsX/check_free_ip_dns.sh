#!/usr/bin/env bash
# Scan a range of IPs and report whether each is used or free.
# If an IP is free, perform a reverse DNS lookup to check for a PTR record.
for ip in 10.219.199.{20..60}; do
    # Ping the IP once with a 1-second timeout.
    # If it responds, the IP is considered used.
    if ping -c1 -W1 "$ip" >/dev/null 2>&1; then
        echo "$ip is used"
    else
        # No ping response → treat as free.
        printf "%s is free" "$ip"

        # Perform reverse DNS lookup (PTR record).
        dns=$(dig +short -x "$ip")

        # If a DNS entry exists, show it; otherwise report none.
        if [ -n "$dns" ]; then
            printf " — DNS entry found: %s\n" "$dns"
        else
            printf " — no DNS entry\n"
        fi
    fi

done
