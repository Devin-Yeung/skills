---
name: explain-with-typeflow
description: Typeflow maps a value's changing typed roles as a tree. Use when the user asks about a type's design or a value's flow across system boundaries.
---

A Typeflow is a rooted projection of either a type's design or a value's provenance. Nodes name a typed role or representation. Edges name the operation and boundary that constructs, transforms, validates, transports, or consumes it.

## Steps

1. Choose the Typeflow branch: type design, value flow, or a changed flow. Name the root value or type and the question it must answer. Complete when the root, scope, and requested outcome are explicit.
2. Inspect every in-scope declaration, constructor, conversion, and consumer. For a value flow, also inspect its entry representation and each terminal representation. Complete when every node and edge intended for the tree has direct source evidence.
3. Draw the Typeflow using the tree notation below. For value flow, follow the typed value from its root to each in-scope terminal role, with transformation edges and explicit success or error children. For type design, draw constructors, cases, and fields that establish the type's invariants. Complete when every in-scope terminal role or construction case relevant to the question is accounted for.
4. Read the design through the Typeflow. State the invariant each relevant type makes explicit and the boundary responsible for every remaining runtime guarantee. Complete when the explanation answers why the types and transformations exist, rather than only restating their names.
5. For a changed flow, mark the changed nodes, edges, or invariants and leave unchanged structure unmarked. Complete when the behavioral delta is visible from the tree.

For a request that also asks how the operation executes, add a separate CallGraph after the Typeflow. Keep their roots and edges independent: the Typeflow follows changing typed roles, while the CallGraph follows execution.

## Typeflow rules

### Tree notation

Start with a one-sentence outcome, then root the tree at the value, representation, or type under discussion. Use the codebase's exact symbols and the target language's native type notation where source provides them.

```text
request body []byte
└─ decodeCreateLink -->
   ├─ request CreateLinkRequest
   └─ err error
```

`-->` shows a semantic transformation or boundary, rather than a language-specific function-type operator. Mark an evidence-backed deduction as `[inferred]`. Use `↩ see <node>` for a shared value or cycle, and mark external systems at the edge that crosses their boundary. Repeat a node only when the repeated provenance is the point of the explanation.

- A call belongs on an edge when it proves a displayed transformation. Calls that do not construct, transform, validate, transport, or consume the displayed role belong to a CallGraph.
- Represent wire data, headers, database rows, messages, and files as representations even when the language has no distinct static type for them.
- Represent static contracts, such as Go interfaces, Rust traits, or generic constraints, at the declaration or conversion they constrain. Runtime value nodes remain values or representations.
- Keep prose to the outcome and design reading. The Typeflow carries the provenance.
