# ARTHA v2 — Development Changelog

## P01 — Structure + Liquidity

Established the causal foundation:

- internal/external pivots;
- HH/HL/LH/LL;
- BOS/CHoCH/MSS;
- protected highs/lows;
- previous D/W/M liquidity;
- swing liquidity;
- EQH/EQL;
- explicit liquidity lifecycle.

## P02 — Displacement

P02/P02.1 were too permissive.

P02.2 moved to relative displacement using recent averages and confirmed selectivity.

P02.3 introduced displacement episodes.

## P03 — FVG / IFVG

Formalized three-candle FVG geometry and inversion lifecycle.

P03.2 introduced primary FVG family ranking by displacement-episode provenance.

## P04 — Causal OB / BB

Replaced generic OB logic with a strict causal chain:

```text
episode → structure break → primary structural FVG → origin candle
```

Breaker Blocks became confirmed lifecycle transitions.

## P05 — Unified POI

Normalized FVG, IFVG, OB and BB into one execution-facing registry.

## P06 — REV

Implemented the reversal state machine:

```text
sweep → shift → POI → retest → reaction → eligible
```

## P07 — CONT

Implemented continuation:

```text
trend → displacement → BOS → POI → pullback → reaction → eligible
```

## P08 — Quality

Added 100-point post-eligibility setup ranking.

## P09 — Signals

Separated setup eligibility from execution signaling.

Added score thresholds, duplicate suppression and signal history.

## P10 / P10.1 — Risk

Added entry, stop and liquidity/fallback targets.

P10.1 fixed drawing lifecycle so risk objects terminate cleanly.

## P11 — Outcomes

Added:

- T1;
- T2;
- stop;
- expiry;
- realized-R tracking;
- conservative same-bar precedence.

## P11.1–P11.3 — Display

Improved active-plan readability and consolidated entry labels.

## P11.4 — Missed Entry Audit

Imported PLUTUS-style reaction concepts as diagnostics.

Initial classification was too permissive.

## P11.5 — Candidate-Aware Audit

Split reactions into:

```text
TRUE_MISS
EARLY
RAW
```

## P11.6 — Direction-Aware Audit

Fixed wrong-direction opportunities.

This became the foundation for the later production reaction-entry model.

## P12 — Production Candidate

Introduced production-focused defaults.

A display issue made historical entries appear absent.

## P12.1–P12.5 — Entry Display / Adaptive Experiments

Explored compact entries, result persistence and adaptive promotion.

These builds exposed Pine main-body size constraints and were not retained as the final architecture.

## P12.6 — Lean Reaction Signals

Reset from P11.6/P12.

Converted:

- TRUE_MISS → valid MISS signal;
- EARLY → valid EARLY signal;
- RAW → ignored.

Removed large audit/diagnostic display machinery.

## P12.7 — Signal Frequency + Display Cleanup

Suppressed repeated same-direction EARLY entries until a meaningful reset.

Compacted terminal result cards.

## P13 — Target Quality

Prevented weak or excessively distant liquidity from forcing unrealistic targets.

Added tier, R-distance and T1/T2-separation filters.

VWAP was explicitly removed from the ARTHA v2 roadmap.

## P14 — Signal Conflict Resolution

Introduced priority:

```text
NORMAL > MISS > EARLY
```

Stronger nearby signals may supersede weaker same-direction signals.

## P15 — Production Consolidation

No trading logic changes.

Consolidated:

- resource budgets;
- alert behavior;
- input terminology;
- retention limits;
- display/calculation separation.

P15 became the production release baseline.


## P15.1 — Target Ordering Hotfix

Cross-checking found two edge cases in P13 target selection.

P15.1 changed target selection to:

```text
finalize T1
→ search all eligible liquidity for nearest valid T2 beyond T1
→ otherwise construct fallback T2 beyond T1
```

This guarantees directional T1/T2 ordering and prevents an invalid nearer second liquidity level from hiding a later valid target.

P15.1 was compile- and visually validated and promoted into `ARTHA_V2_Production.pine`.
