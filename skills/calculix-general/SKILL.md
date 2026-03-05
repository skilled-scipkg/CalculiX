---
name: calculix-general
description: Use this skill for most CalculiX requests (input modeling, run/validate, output interpretation, and troubleshooting) with docs-first escalation to tests and then source.
---

# calculix: General

## High-Signal Playbook

### Route conditions
- Use this skill when the user asks about input-deck modeling, run execution, result validation, output interpretation (`.dat`/`.frd`), or convergence troubleshooting.
- Keep escalation order explicit: manual first (`doc/CalculiX.tex`), then runnable test decks and harness scripts (`test/`), then solver source (`src/`).
- Jump to source only when behavior is still ambiguous after docs/tests (for example solver branch selection, convergence loop internals, or output writer behavior).

### Triage questions
1. Which analysis procedure is intended (`*STATIC`, `*DYNAMIC`, `*FREQUENCY`, `*BUCKLE`, coupled thermo-mechanical)?
2. Is this a new model setup or a failing existing `.inp` deck?
3. Which failure mode appears first: input parse, solver/convergence, or post-processing/output mismatch?
4. Which unit system is being used, and were density/modulus/loads scaled consistently?
5. Do you need table output (`.dat`), visualization output (`.frd`), or both?
6. Is contact active; if yes, which contact formulation and element order are used?
7. Is runtime behavior affected by thread/env settings (`OMP_NUM_THREADS`, `CCX_NPROC_*`)?

### Simulation bootstrap (first real run)
```bash
# From repository root: resolve binary, run a known-good deck, and check outputs.
./skills/calculix-general/scripts/smoke_run.sh simplebeam
```

Manual fallback when a helper script is not preferred:
```bash
CCX_BIN="$(./skills/calculix-general/scripts/smoke_run.sh --resolve-bin)"
cd test
"${CCX_BIN}" simplebeam
ls -lh simplebeam.dat simplebeam.frd
```

### Canonical workflow
1. Confirm analysis type and unit system using the manual sections `Units`, `Golden rules`, and relevant keyword subsections (`doc/CalculiX.tex`).
2. Build model-definition cards before the first `*STEP` (`*NODE`, `*ELEMENT`, sets, materials, sections; `doc/CalculiX.tex:404`).
3. Define load/procedure cards inside `*STEP ... *END STEP` (`doc/CalculiX.tex:448`).
4. Request output intentionally: `*NODE PRINT`/`*EL PRINT` for `.dat`, `*NODE FILE`/`*EL FILE` for `.frd` (`doc/CalculiX.tex:454-460`).
5. Run with a jobname (`src/CalculiX.c` supports `-i jobname` and direct jobname argument).
6. Validate artifacts and convergence traces (`.dat`, `.frd`, `.sta`, `.cvg`, optional `ResultsForLastIterations.frd`; `doc/CalculiX.tex:334`).
7. Use lightweight checks first (`ls`, `grep -n "NaN"`) before full regression scripts.
8. For regression confidence, use `test/README` + `test/compare` (or `test/compare_par`) to compare outputs with `*.ref`.
9. If `test/compare*` fails due its hardcoded home-directory binary location, either use `smoke_run.sh` + `datcheck.pl`/`frdcheck.pl` or run with a local symlink-compatible layout.

### Minimal working example
```inp
** Minimal structural static deck (derived from test/simplebeam.inp)
*NODE,NSET=Nall
1, 0, 0, 0
2, 0, 0, 5
3, 0, 0, 10
*ELEMENT,TYPE=B32R,ELSET=EAll
1,1,2,3
*BOUNDARY
3,1,6
*MATERIAL,NAME=ALUM
*ELASTIC
1E7,.3
*BEAM SECTION,ELSET=EAll,MATERIAL=ALUM,SECTION=RECT
.25,.25
1.d0,0.d0,0.d0
*STEP
*STATIC
*CLOAD
1,1,1.
*NODE FILE,OUTPUT=2D
U
*END STEP
```

```bash
# Run and verify artifacts
CalculiX -i simplebeam   # equivalent form accepted: CalculiX simplebeam
ls simplebeam.dat simplebeam.frd

# Optional regression harness across test decks
cd test && ./compare
```

### Pitfalls and fixes
- Inconsistent units produce physically wrong answers: lock one consistent base-unit system first (`doc/CalculiX.tex`, section `Units`).
- Misplaced cards break deck logic: keep model cards before first `*STEP`; keep step cards between `*STEP` and `*END STEP` (`doc/CalculiX.tex:404-458`).
- Missing `.dat` output is often configuration, not solver failure: add `*NODE PRINT` or `*EL PRINT` (`doc/CalculiX.tex:454`).
- Nonlinear divergence is often setup-driven: run a linearized version first (drop `NLGEOM`, material/contact nonlinearity) (`doc/CalculiX.tex`, section `Golden rules`).
- For nonlinear implicit structural work, avoid low-order element traps: prefer quadratic elements except explicit dynamics (`doc/CalculiX.tex`, section `Golden rules`).
- Contact with quadratic elements can stall in node-to-face mode: prefer face-to-face penalty or mortar (mortar is static-only) (`doc/CalculiX.tex`, section `Golden rules`).
- Memory pressure can be numbering-driven: remove large node/element ID gaps; consider iterative solver options (`doc/CalculiX.tex`, section `Golden rules`).
- Segfault triage without visibility is slow: set `CCX_LOG_ALLOC=1` to log allocations (`doc/CalculiX.tex:365`).

### Convergence/validation checks
1. Mesh and formulation sanity: check mesh quality and suitable element order before deep solver debugging.
2. Boundary/load sanity: a linearized run should behave physically before enabling full nonlinear features.
3. Nonlinear progress: inspect `.sta` and `.cvg`; use last-iterations/contact-element outputs when convergence stalls (`doc/CalculiX.tex:334`).
4. Output completeness: verify requested fields are actually present in `.dat`/`.frd` (`doc/CalculiX.tex:454-460`).
5. Numerical sanity: reject runs with `NaN` in `.dat` (`grep -n "NaN" <job>.dat`).
6. Regression confidence: compare against `*.ref` outputs via `test/compare`/`test/compare_par`, or targeted `test/datcheck.pl` and `test/frdcheck.pl` for single-job checks.

## Scope
- Handle broad CalculiX usage questions with doc-backed, workflow-level guidance.
- Keep answers compact and practical; only dive into per-function source details when docs/tests are insufficient.

## Primary documentation references
- `doc/CalculiX.tex`
- `test/README`

## Workflow
- Start in `doc/CalculiX.tex`; cite exact section/keyword anchors whenever possible.
- Use `references/doc_map.md` to jump to high-signal manual anchors and runnable test references.
- Use `test/*.inp` and `test/compare*` for executable examples and behavior/regression checks.
- Prefer `skills/calculix-general/scripts/smoke_run.sh` when bringing up a new workspace quickly.
- Escalate to `references/source_map.md` only for unresolved implementation-level behavior.

## Tutorials and examples
- `test`

## Test references
- `test`

## Optional deeper inspection
- `src`

## Source entry points for unresolved issues
- `src/CalculiX.c` (`main`, analysis dispatch: `linstatic`, `nonlingeo`, `arpack*`)
- `src/readinput.c` (`readinput`) and `src/openfile.f` (`openfile`) for deck/file lifecycle.
- `src/linstatic.c` (`linstatic`) and `src/nonlingeo.c` (`nonlingeo`) for solve-driver behavior.
- `src/checkconvergence.c` (`checkconvergence`) and `src/calcresidual.c` (`calcresidual`) for nonlinear convergence diagnostics.
- `src/arpack.c`, `src/arpackcs.c`, `src/arpackbu.c` (`arpack*`) for frequency/buckling branches.
- `src/spooles.c` (`spooles`) and `src/preiter.c` (`preiter`) for solver-path selection.
- `src/results.c` (`results`), `src/frd.c` (`frd`), and `src/frdcyc.c` (`frdcyc`) for output generation behavior.
- Prefer targeted source search (for example: `rg -n "<symbol_or_keyword>" src`).
