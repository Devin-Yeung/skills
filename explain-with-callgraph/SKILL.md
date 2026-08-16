---
name: explain-with-callgraph
description: Call graphs map execution relationships as a tree. Use when the user asks about calls between functions or the control path through an operation.
---

A CallGraph is a rooted projection of execution. Nodes name entries, guards, calls, concurrent work, and terminal effects. Edges state the call, condition, or control operation that reaches the child.

## Steps

1. Name the operation, entry point, and control question. Complete when the root and the terminal effects or decisions the user needs to understand are explicit.
2. Inspect every in-scope call, guard, dispatch, concurrency boundary, and terminal effect. Complete when every node and edge intended for the tree has direct source evidence.
3. Draw the CallGraph using the tree notation below from the entry to each in-scope terminal effect. Make branch conditions, error handling, retries, dispatch, goroutines, queues, callbacks, and cancellation visible when they alter execution. Complete when every distinct in-scope path to a displayed terminal effect is accounted for.
4. Add the control reading: state the operation's decisive guard, lifecycle boundary, or concurrency hand-off. Complete when the explanation answers how execution reaches its outcome, rather than only listing callers and callees.
5. For a changed control path, mark the changed nodes, edges, or branch conditions and leave unchanged structure unmarked. Complete when the behavioral delta is visible from the tree.

For a request that also asks how values change shape, add a separate Typeflow before the CallGraph. Keep their roots and edges independent: the Typeflow follows changing typed roles, while the CallGraph follows execution.

## CallGraph rules

### Tree notation

Start with a one-sentence outcome, then root the tree at the entry point under discussion. Use the codebase's exact function, method, module, and package symbols where source provides them.

```text
POST /v1/links
└─ CreateHandler.ServeHTTP -->
   ├─ decodeCreateLink
   │  └─ [error] writeBadRequest
   └─ links.Create
      └─ [created] writeCreated
```

`-->` shows a call, guard, dispatch, or concurrency relation, rather than a language-specific function-type operator. Mark an evidence-backed deduction as `[inferred]`. Use `↩ see <node>` for a shared call or cycle, and mark external systems at the edge that crosses their boundary. Repeat a node only when the repeated execution path is the point of the explanation.

- Use guard nodes for control decisions and call nodes for execution hand-offs. A value transformation appears only when it determines the displayed branch; its full provenance belongs to a Typeflow.
- Mark interface dispatch, callbacks, goroutines, queues, and external services at their boundary. List concrete implementations only when their selection is directly evidenced.
- Keep local statements inside a node when they neither fork control nor create an execution hand-off.
- Keep prose to the outcome and control reading. The CallGraph carries the execution relationship.
