# calculix documentation map: General

Generated from documentation roots:
- `doc`
- `test`

Total docs grouped in this topic: 1

## Core references for first-pass answers
- `doc/CalculiX.tex` (primary user manual and keyword reference)
- `test/README` (how to run serial/parallel regression comparisons)
- `test/simplebeam.inp` (compact runnable baseline deck)
- `test/compare` and `test/compare_par` (reference-output validation harness)

## Simulation-ready quick start
```bash
# Repository root
./skills/calculix-general/scripts/smoke_run.sh simplebeam
```

Expected checkpoint artifacts:
- `<job>.dat` exists and is non-empty in `test/`.
- `<job>.frd` exists and is non-empty in `test/`.
- Optional nonlinear diagnostics appear in `.sta`/`.cvg` when applicable.

Targeted single-case comparisons:
```bash
cd test
./datcheck.pl simplebeam
./frdcheck.pl simplebeam   # only if simplebeam.frd.ref exists
```

Note: `test/compare` and `test/compare_par*` call a hardcoded home-directory binary location; use them directly only when that location is valid in your environment.

## High-signal manual anchors (line numbers in `doc/CalculiX.tex`)
- `37`: Parallel execution and environment controls (`OMP_NUM_THREADS`, `CCX_NPROC_*`).
- `143`: Unit-system consistency guidance.
- `267`: Golden rules for mesh, nonlinear setup, contact, and memory.
- `334`: Troubleshooting checklist (`.sta`, `.cvg`, last-iterations/contact outputs, `CCX_LOG_ALLOC`).
- `376` and `378`: Simple example section and cantilever walkthrough.
- `404`: Input deck structure: model-definition cards before first `*STEP`.
- `448`: Step semantics between `*STEP` and `*END STEP`.
- `454-460`: Output card behavior and `.dat` vs `.frd` semantics.
- `18919`: Full input-deck keyword reference section.
- `32637`: Program structure overview.
- `34978`: Solver-path mapping and analysis workflow internals.

## Quick keyword jump points
- `25365`: `*HEADING`
- `27109`: `*NODE`
- `23443`: `*ELEMENT`
- `27556`: `*NSET`
- `24023`: `*ELSET`
- `26451`: `*MATERIAL`
- `23139`: `*ELASTIC`
- `28909`: `*SOLID SECTION`
- `19219`: `*BOUNDARY`
- `20053`: `*CLOAD`
- `29410`: `*STEP`
- `29143`: `*STATIC`
- `23009`: `*DYNAMIC`
- `24756`: `*FREQUENCY`
- `19508`: `*BUCKLE`
- `27145`: `*NODE FILE`
- `23622`: `*EL FILE`
- `27381`: `*NODE PRINT`
- `23872`: `*EL PRINT`
- `28392`: `*RESTART`
