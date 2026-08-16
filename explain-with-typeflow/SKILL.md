---
name: explain-with-typeflow
description: Trace code behavior with call-graph trees and type-flow trees. Use when the user asks how a system works, asks to explain code changes, or requests call graph/type flow diagrams.
---

Use this skill to explain code by tracing execution and data together. The output should make the system feel navigable: what calls what, what types cross each seam, and where behavior changes.

## Steps

1. Identify the explanation branch: system behavior, code changes, or both. Complete when the scope is clear from the user's wording or from the changed files/diff.
2. Do enough legwork to ground the trace in code. For system behavior, find the entry points, core orchestrators, and terminal effects. For changes, inspect the diff plus adjacent call sites and changed types. Complete when every named edge in the output is backed by code you inspected.
3. Write the call graph as a tree. Use function/module names as nodes, indent child calls under callers, and annotate important branches with short labels like `success`, `retry`, `error`, or `shutdown`. Complete when a reader can follow runtime control from entry point to terminal effect.
4. Write the type flow as a tree. Show structs/enums/traits/generics moving through the flow, including conversions, serialized forms, headers, DTOs, messages, errors, and trait seams. Complete when every major boundary names the type shape that crosses it.
5. Add a short interpretation. Explain the core idea, the important seam, or the behavioral impact of the change in one concise paragraph. Complete when the tree is connected to the user's practical question, not left as raw structure.

## Output shape

Prefer this order:

```text
call graph
└── entry_point()
    ├── orchestrator()
    │   ├── branch_a()
    │   └── branch_b()
    └── terminal_effect()
```

```text
type flow
└── InputType
    └── DomainType
        └── TransportType
            └── OutputType
```

Then add a short explanation paragraph.

## Rules

- Lead with the highest-level outcome before the trees.
- Keep trees structural: one node per meaningful call, type, conversion, or boundary.
- Use exact symbol names when known; use descriptive labels only when the code has no named symbol.
- Do not invent edges. If an edge is inferred, mark it as inferred or omit it.
- For code changes, distinguish existing flow from changed flow only where behavior actually differs.
- Keep prose sparse; the trees carry the explanation.
