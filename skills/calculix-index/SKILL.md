---
name: calculix-index
description: Use this router first for CalculiX requests; classify by intent (install/build, modeling, run/validate, post-processing, troubleshooting) and then route docs-first to topic skills.
---

# calculix Skills Index

## Route the request
- Classify the request by intent first, then route to the generated topic skill.
- Keep guidance docs-first and workflow-level; avoid source deep-dives until docs/tests are insufficient.

## Intent routing
- Install/build/runtime environment (including threading vars and solver availability) -> `calculix-general`.
- Input modeling and keyword authoring (`.inp` structure, cards, procedure selection) -> `calculix-general`.
- Run and validate (job execution, output files, regression checks) -> `calculix-general`.
- Post-processing/output interpretation (`.dat`, `.frd`, cgx-facing outputs) -> `calculix-general`.
- Troubleshooting (convergence, contact issues, crash triage) -> `calculix-general`.

## Generated topic skills
- `calculix-general`: General (documentation grouped under the 'general' theme)

## Documentation-first inputs
- `doc/CalculiX.tex`

## Tutorials and examples roots
- `test`

## Test roots for behavior checks
- `test`

## Escalate only when needed
1. Start in topic primary docs (`doc/CalculiX.tex` through `calculix-general`).
2. If unclear, move to runnable test evidence (`test/README`, `test/*.inp`, `test/compare*`).
3. For first-run readiness in a fresh workspace, use `skills/calculix-general/scripts/smoke_run.sh` before broad troubleshooting.
4. Only then inspect source via topic `references/source_map.md` entry points.
5. Use targeted symbol search while inspecting source (for example `rg -n "<symbol_or_keyword>" src`).

## Source directories for deeper inspection
- `src`
