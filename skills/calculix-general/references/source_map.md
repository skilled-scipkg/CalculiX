# calculix source map: General

Generated from source roots:
- `src`

Use this map only after exhausting the topic docs in `references/doc_map.md`.

## Topic query tokens
- `general`
- `readinput`
- `linstatic`
- `nonlingeo`
- `arpack`
- `spooles`
- `preiter`
- `results`
- `frd`
- `checkconvergence`
- `calcresidual`

## Fast source navigation
- `rg -n "main\\(|readinput\\(|ini_cal\\(|linstatic\\(|nonlingeo\\(|arpack\\(|arpackcs\\(|arpackbu\\(" src/CalculiX.c src/CalculiXstep.c`
- `rg -n "checkconvergence|calcresidual|contact|remastruct|tempload" src/nonlingeo.c src/*.c src/*.f`
- `rg -n "spooles\\(|preiter\\(" src/linstatic.c src/nonlingeo.c src/arpack*.c src/spooles.c src/preiter.c`
- `rg -n "NODE FILE|EL FILE|NODE PRINT|EL PRINT|\\.frd|\\.dat" src/results* src/frd* src/outputs.f`

## Function-level entry points (verified existing paths)
- CLI and top-level branch selection:
  `src/CalculiX.c` (`main`) and `src/CalculiXstep.c` (step-dispatch variant).
- Deck/file lifecycle:
  `src/readinput.c` (`readinput`) and `src/openfile.f` (`openfile`).
- Linear and nonlinear solve drivers:
  `src/linstatic.c` (`linstatic`) and `src/nonlingeo.c` (`nonlingeo`).
- Nonlinear convergence internals:
  `src/checkconvergence.c` (`checkconvergence`) and `src/calcresidual.c` (`calcresidual`).
- Contact behavior:
  `src/contact.c` (`contact`) and `src/contactmortar.c` (`contactmortar`).
- Frequency and buckling branches:
  `src/arpack.c` (`arpack`), `src/arpackcs.c` (`arpackcs`), `src/arpackbu.c` (`arpackbu`).
- Solver backend selection:
  `src/spooles.c` (`spooles`) and `src/preiter.c` (`preiter`) callsites in `linstatic`/`nonlingeo`/`arpackbu`.
- Matrix assembly:
  `src/mafillsmmain.c` (`mafillsmmain`) and `src/mafillsm.f`.
- Output generation:
  `src/results.c` (`results`), `src/results*.f`, `src/frd.c` (`frd`), and `src/frdcyc.c` (`frdcyc`).
- Diagnostic output helpers:
  `src/writeboun.f`, `src/writempc.f`, and `src/cascade.c`.

## Behavior checks by symptom
- Wrong analysis branch selected:
  `rg -n "linstatic\\(|nonlingeo\\(|arpack\\(|arpackcs\\(|arpackbu\\(" src/CalculiX.c src/CalculiXstep.c`
- Input cards parsed but model behaves unexpectedly:
  `rg -n "readinput\\(|\\*STEP|\\*END STEP" src/readinput.c doc/CalculiX.tex`
- Nonlinear stagnation or divergence:
  `rg -n "checkconvergence\\(|calcresidual\\(|iit|icntrl|qa\\[" src/nonlingeo.c src/checkconvergence.c src/calcresidual.c`
- Contact activation surprises:
  `rg -n "contact\\(|contactmortar\\(|mortar" src/nonlingeo.c src/contact.c src/contactmortar.c`
- Solver backend mismatch (direct vs iterative):
  `rg -n "spooles\\(|preiter\\(|isolver" src/linstatic.c src/nonlingeo.c src/arpackbu.c`
- Missing `.dat`/`.frd` fields:
  `rg -n "results\\(|frd\\(|frdcyc\\(|NODE FILE|EL FILE|NODE PRINT|EL PRINT" src/results.c src/frd.c src/frdcyc.c src/outputs.f doc/CalculiX.tex`
