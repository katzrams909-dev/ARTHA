# ARTHA v2 P12 — Indicator Stabilization & Production Candidate

## Objective

Freeze the validated v2 architecture into an indicator-first production candidate.

P12 deliberately does **not** add a TradingView strategy harness and does not add new trading logic.

## Runtime profiles

### Production — default

Designed for normal chart use.

Defaults:

- Runtime profile: Production
- Display mode: Execution
- Diagnostic panel: OFF
- Unified POI diagnostics: OFF
- Quality diagnostics: OFF
- Outcome diagnostics: OFF
- PLUTUS reaction audit: OFF
- true-miss labels: OFF
- early-opportunity markers: OFF

The underlying structure, liquidity, displacement, POI, REV/CONT, quality, signal, risk and outcome engines continue to calculate normally.

### Research

Research mode permits the P11.6 reaction audit to run when its audit toggle is enabled.

This preserves the missed-entry research workflow without mixing it into the production view.

## Production pipeline

```text
Structure
→ Liquidity
→ Relative Displacement
→ Displacement Episodes
→ FVG / IFVG
→ Primary FVG Families
→ Causal OB / BB
→ Unified POI
→ REV / CONT Eligibility
→ Quality
→ Signals
→ Risk / Targets
→ Outcome Tracking
```

## Research-only layer

```text
Unified POI interaction
→ PLUTUS-style reaction classifier
→ TRUE MISS / EARLY / RAW audit
```

The audit does not modify production eligibility or signals.

## Display policy

Execution mode remains the preferred production view:

- consolidated ENTRY tag
- SL / T1 / T2
- high-priority liquidity
- essential POIs
- redundant eligibility/signal text suppressed

Analysis and Full modes remain available for inspection.

## Production contract

Before promotion beyond P12:

1. compile on Pine v6;
2. reload without historical changes;
3. test FX, index and metal samples;
4. verify chart remains readable at normal zoom;
5. verify Production vs Research profile does not change core signal counts;
6. verify audit enable/disable cannot change REV/CONT/P09 state;
7. inspect object counts on long histories.

P12 is the first production-candidate build, not a claim of statistically validated profitability.
