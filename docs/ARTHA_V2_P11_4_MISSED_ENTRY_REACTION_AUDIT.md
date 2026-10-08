# ARTHA v2 P11.4 — Missed Entry Reaction Audit

## Purpose

Diagnose whether ARTHA is missing otherwise valid POI reactions because its REV/CONT retest/confirmation sequence is too restrictive.

P11.4 does **not** create new ARTHA entries.

It compares the existing ARTHA pipeline against a narrow reaction adapter derived from PLUTUS P09.2.

## Imported PLUTUS mechanics

Only POI interaction mechanics are reused:

- REJECTION
- SWEEP_RECLAIM
- FLIP_RETEST

The following PLUTUS systems are deliberately **not** imported:

- RVOL / participation scoring
- VWAP context
- value context
- ADX regime filtering
- session filtering
- PLUTUS setup-quality thresholds

This keeps the test focused on entry timing rather than changing ARTHA's causal model.

## Interaction classes

### REJECTION

Price overlaps an active POI and does not sweep through its far boundary.

### SWEEP_RECLAIM

Price sweeps beyond the far POI boundary, the excess sweep remains within the configured ATR tolerance, and the close reclaims the required side of the POI.

Default maximum sweep:

`0.35 ATR`

### FLIP_RETEST

An active IFVG or Breaker is retested.

## Confirmation timing

Reaction confirmation can occur:

- on the touch bar when enabled;
- within 1, 2, or 3 bars after interaction.

Default window: 3 bars.

Close modes:

- Directional Close
- Midpoint Reclaim
- Any Valid Close

Default: Directional Close.

## Family attribution

The adapter does not invent a third setup family.

It attributes the interaction to REV or CONT using ARTHA context:

1. active REV state;
2. active CONT state;
3. recent REV liquidity-sweep context;
4. established external CONT trend.

If none applies, the interaction is ignored.

## Captured vs missed

A PLUTUS-style reaction is **captured** when ARTHA produces REV/CONT eligibility or a P09 signal during the reaction window.

Otherwise it becomes a diagnostic missed-entry event.

Miss reasons identify the ARTHA state at confirmation:

REV:
- WAIT_SHIFT
- WAIT_POI
- WAIT_RETEST
- REACTION_GATE
- NO_ACTIVE_REV_STATE

CONT:
- WAIT_POI
- WAIT_RETEST
- REACTION_GATE
- NO_ACTIVE_CONT_STATE

## Visual marker

Example:

```text
MISS? CONT · SWEEP_RECLAIM
FVG#696 · WAIT_RETEST
```

This is an audit marker, not a BUY/SELL signal.

## Exit gate

Collect examples from the GBPUSD, AUDUSD, EURUSD and index charts.

Only after the same miss reason repeats consistently should the underlying ARTHA entry gate be changed.
