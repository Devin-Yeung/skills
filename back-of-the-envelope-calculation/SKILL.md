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

### CPU

| Operations               | Latency (measure in time) | Latency (measure in cycles) |
| ------------------------ | ------------------------- | --------------------------- |
| L1 cache                 | 1 ns                      | 4 cycles                    |
| L2 cache                 | 4 ns                      | 12 cycles                   |
| L3 cache                 | 13 ns                     | 40 cycles                   |
| Cross-core communication | 30 ns                     | 100 cycles                  |
| RAM access               | 100 ns                    | 300 cycles                  |

### Disk

The measurements of random R/W and sequential R/W are different on purpose, as they represent different access patterns:

- Random R/W: Accessing data at random locations on the disk, where the overhead of seeking is significant, latency is the primary concern.
- Sequential R/W: Accessing data in a contiguous manner, the overhead of seeking is minimized, throughput is the primary concern.

| Operations          | Latency                    |
| ------------------- | -------------------------- |
| NVMe SSD random R/W | 10 ~ 30 µs (take 20 µs)    |
| SATA SSD random R/W | 100 ~ 200 µs (take 150 µs) |
| HDD random R/W      | 10 ms                      |

| Operations              | Throughput             |
| ----------------------- | ---------------------- |
| NVMe SSD sequential R/W | 4,000 ~ 10,000 MiB / s |
| SATA SSD sequential R/W | 450 ~ 550 MiB / s      |
| HDD sequential R/W      | 150 ~ 250 MiB/ s       |

### Network and services

| Operations                    | Latency |
| ----------------------------- | ------- |
| Network round-trip (same DC)  | 0.5 ms  |
| Network round-trip (cross-DC) | 150 ms  |
| Typical HTTP request          | 1–10 ms |
