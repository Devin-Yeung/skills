---
name: call-tree
description: Trace the execution paths relevant to a code-review question as a compact call tree. Use for control paths, guards, errors, and important effects or hand-offs.
---

## Steps

1. Name the root operation and the review question.
2. Inspect the code on the paths needed to answer it.
3. Draw the Call Tree. Show calls, branching conditions, outcomes, and effects or hand-offs that matter to the question.

## Notation

```text
<root>
├── <step>
│   └── [<label>] => <outcome>
├── [<label>] <step>
│   └── ~> <effect or hand-off>
└── => <outcome>
```

- A bare name is a step on the execution path: a call, operation, boundary, or other action that matters to the review.
- `[label]` names why or how a path is reached: a condition, state, choice, phase, or entry mechanism. Add one when the bare tree would hide that context.
- `=>` marks an outcome: a return, error, response, or other terminal result.
- `~>` marks an effect or hand-off important to the review, such as persistence, publishing an event, or delegating work to another program.

## Example

```text
OrderController.checkout
├── checkCartValid
│   └── [empty] => 400 BadRequest
├── paymentGateway.charge
│   ├── [declined] => 402 PaymentRequired
│   └── [approved]
│       ├── orderRepo.markPaid
│       └── ~> worker.sendReceiptEmail
└── => 200 OK
```
