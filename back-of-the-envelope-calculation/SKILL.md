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

## Common constants to define in numbat

```
# Traffic
let rps = <n> Hz               # requests per second
let rpd = rps * 1 day          # requests per day

# Storage
let row_size = <n> byte
let retention = <n> year
let total_storage = rps * row_size * retention

# Bandwidth
let read_ratio = <n>           # dimensionless
let write_ratio = <n>
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

| Unit        | Value                       |
| ----------- | --------------------------- |
| 1 KB        | 10³ bytes                   |
| 1 MB        | 10⁶ bytes                   |
| 1 GB        | 10⁹ bytes                   |
| 1 TB        | 10¹² bytes                  |
| 1 PB        | 10¹⁵ bytes                  |
| 1 day       | 86,400 s ≈ 10⁵ s            |
| 1 month     | 2.6 × 10⁶ s                 |
| 1 year      | 3.15 × 10⁷ s                |

## Workflow

1. **Clarify the unknowns** — identify what needs to be estimated (QPS, storage, bandwidth, latency budget, server count).
2. **State assumptions explicitly** — write them out before calculating.
3. **Run numbat** — express calculations as unit-aware expressions so numbat catches dimensional errors.
4. **Interpret the result** — round to 1–2 significant figures, flag bottlenecks, note where assumptions dominate.
5. **Sanity-check** — compare against known reference numbers above.

## Example

User: "Estimate storage for a URL shortener serving 100M writes/day, keeping URLs for 5 years."

```
numbat <<'EOF'
let writes_per_day = 100_000_000 / day
let row_bytes = 500 byte        # short URL + long URL + metadata
let retention = 5 year
let total = writes_per_day * row_bytes * retention -> TB
total
EOF
```
