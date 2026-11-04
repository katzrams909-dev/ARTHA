# ARTHA v2 P17.27.1 — CE10295 Main-Body Reduction

## Status
Committed to GitHub branch `artha-v2-p17-presets`. TradingView compilation has not yet been confirmed. P17.26.5.1 remains the previously compile-confirmed midpoint audit baseline. Original P17.27 source is preserved.

## Reported compiler error
`The main body of the script is too long. Try wrapping code in functions (CE10295)` after introducing P17.27 OTE observation. This is a main-body compilation constraint, distinct from CE10117 token limits.

## Focused change
- Extracted OTE lifecycle updates from top-level into `f_updateOTEShadow()` and invoke it once in the same top-level position.
- Extracted OTE table cell updates into `f_renderOTEShadow()`; execute on the last bar only.
- Both functions update existing OTE arrays/table but do not change their geometry, source eligibility, structure-break anchors, overlap criteria or counters.
- The OTE update continues before the risk-plan engine, retaining the same order of side effects. No source POI or production signal arrays are changed.
- P17.27 OTE inputs, 62/70.5/79 levels, maximum-age semantics, non-retroactive birth and POI overlap detection remain unchanged.
- All P17.26.5.1 midpoint LTF and evidence aggregation logic is preserved; no changes to REV/CONT, EARLY/MISS or structural SL/TP1–TP4.

## Validation
1. Compile P17.27.1 in TradingView Pine v6; report exact new error/line if any. The source was structurally checked, not compiled in TradingView.
2. Compare P17.26.5.1 on same AUDUSD 5m for source signals, risk plans, and midpoint audit metrics.
3. Enable the OTE shadow dashboard; confirm qualified ranges and 62–79/70.5 touch counters move only when a confirmed structural break exists and later bars retrace.
4. Verify frozen origin/impulse geometry and unchanged production REV/CONT/EARLY/MISS signals.
5. If CE10295 persists, extract another self-contained top-level calculation block without changing entry logic; if CE10117 emerges, optimize compiled token footprint separately.