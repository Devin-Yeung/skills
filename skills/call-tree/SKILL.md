---
name: call-tree
description: Trace the execution paths relevant to a code-review question as a compact call tree. Use for control paths, guards, errors, and important effects or hand-offs.
---

## Steps

1. Name the root operation and the review question.
2. Inspect the code on the paths needed to answer it.
3. Draw the Call Tree with the steps, labels, outcomes, and effects or hand-offs needed to answer it.

## Notation

```text
<root>
├── <step>
├── [<label>] <step>
│   └── ~> <effect or hand-off>
├── <step>
│   └── [<label>] => <outcome>
└── => <outcome>
```

- A bare name is a step on the execution path: a call, operation, boundary, or other action that matters to the review.
- `[label]` is optional path context: a condition, state, choice, phase, or entry. Add it when the bare tree would hide why or how the path is reached.
- `=>` marks an outcome: a return, error, response, or other terminal result.
- `~>` marks an effect or hand-off important to the review, such as persistence, publishing an event, or delegating work to another program.

## Example

```text
OrderController.checkout
├── checkCartValid
│   └── => 400 BadRequest
├── paymentGateway.charge
│   ├── [declined] => 402 PaymentRequired
│   └── [approved]
│       ├── orderRepo.markPaid
│       └── ~> worker.sendReceiptEmail
└── => 200 OK
```
