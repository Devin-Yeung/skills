---
name: control-flow-review
description: Make code changes reviewable by exposing their effect on execution paths. Use when a review depends on branching, errors, concurrency, or cross-component calls.
---

# Control-Flow Review

Use `call-tree` to establish the relevant paths. Present the smallest evidence that makes the behavioral change easy to review; prefer a behavioral `.diff` call tree when a before/after contrast is clearest.
