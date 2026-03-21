---
name: Back-of-the-envelope calculation
description: Perform back-of-the-envelope calculations for system design estimation. Use when user wants to quickly estimate quantities on the order of magnitude, such as QPS, storage, bandwidth, latency, or server count. Or mentions "back of the envelope", roughly estimate", or similar.
---

## How to use

When the user describes a system design problem or estimation question, break it down into measurable quantities, then use `numbat` to compute the results.

Run calculations with:
```
numbat -e "<expression>"
```

Or for multi-line calculations:
```
numbat <<'EOF'
<expressions>
EOF
```

## Best Practices

Define ad-hoc units as needed, numbat helps catch dimensional errors and ensures consistent calculations. 

```
@aliases(urls)
unit url # a dimension called `Url` is created automatically

let urls_per_sec = 1000 url/s      # dimension of Url * Time
let urls_in_a_day = rps * 1 day    # dimension of Url
```

## Workflow

1. **Clarify the unknowns** — identify what needs to be estimated (QPS, storage, bandwidth, latency budget, server count).
2. **State assumptions explicitly** — write them out before calculating.
3. **Run numbat** — express calculations as unit-aware expressions so numbat catches dimensional errors.
4. **Interpret the result** — round to 1–2 significant figures, flag bottlenecks, note where assumptions dominate.
5. **Sanity-check** — compare against known reference numbers below to check if the result is in the right ballpark.

## Example

User: "Estimate storage for a URL shortener serving 1000 urls/sec, keeping URLs for 5 years."

```
numbat <<'EOF'

@aliases(urls)
unit url

let urls_per_sec = 1000 urls / s

let bytes_per_record = 500 byte / url  # short URL + long URL + metadata
let retention = 5 year

let total = urls_per_sec * bytes_per_record * retention -> TB
total

EOF
```

## Reference numbers (encode as needed)

| Resource                        | Latency / Size        |
| ------------------------------- | --------------------- |
| L1 cache                        | 0.5 ns                |
| L2 cache                        | 7 ns                  |
| RAM access                      | 100 ns                |
| SSD random read                 | 150 µs                |
| HDD seek                        | 10 ms                 |
| Network round-trip (same DC)    | 0.5 ms                |
| Network round-trip (cross-DC)   | 150 ms                |
| Typical HTTP request            | 1–10 ms               |
| MySQL/Postgres read (simple)    | 1 ms                  |
| MySQL/Postgres write            | 5 ms                  |
| Redis get                       | 0.1 ms                |
| HDD throughput                  | 100 MB/s              |
| SSD throughput                  | 500 MB/s              |
| NIC throughput                  | 1 Gbps                |
| Typical server RAM              | 256 GB                |
| Typical server cores            | 64                    |
