---
name: call-tree
description: Answer control-flow questions with a compact call tree of an operation's execution paths.
---

## Steps

1. Name the root operation and the control-flow question.
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

- A bare name is a step on the execution path: a call, operation, boundary, or other action that matters to the question.
- Among sibling steps, top-to-bottom order is execution order.
- A standalone `[concurrent]` node groups direct children that execute concurrently. Its scope ends at those children; nested siblings remain sequential unless another `[concurrent]` node groups them.
- `[label]` is optional path context: a condition, state, choice, phase, or entry. It can prefix a step or stand alone as a branch node whose children occur in that context. Add it when the bare tree would hide why or how the path is reached.
- `=>` marks an outcome: a return, error, response, or other terminal result.
- `~>` marks an effect or hand-off important to the question, such as persistence, publishing an event, or delegating work to another program.

## Example

```text
OrderController.checkout
├── checkCartValid
│   └── [invalid] => 400 BadRequest
├── paymentGateway.charge
│   ├── [declined] => 402 PaymentRequired
│   └── [approved]
│       ├── orderRepo.markPaid
│       └── [concurrent]
│           ├── ~> receiptWorker.sendEmail
│           └── ~> analytics.recordPurchase
└── => 200 OK
```
