# ARTHA v2 P17.2 — Terminal Label Cleanup

## Purpose

Keep historical result cards while removing obsolete trade-specific labels after the associated risk plan reaches a terminal outcome.

## Terminal outcomes
- T2 HIT
- STOPPED
- EXPIRED

## Cleanup behavior

On terminal outcome, delete the plan's signal marker, entry/detail tag, stop tag, T1 tag, T2 tag, and status tag.

The recent-entry result card is managed separately and remains visible according to existing history settings, including results such as `STOPPED · -1.00R`.

Risk lines remain governed by the existing `Show terminal risk plans` behavior. Other active trades are not modified.

The existing first-TP marker cleanup remains in effect. A plan that reaches T1 but is still active can continue to show its T1 state until a terminal outcome occurs; at terminal outcome, all per-trade text labels are removed.

## Unchanged
- Preset calibration
- Signal admission and priority
- Entry/SL/T1/T2 prices
- Outcome calculations and attribution
- Recent result card retention
- Risk line lifecycle settings

## Validation target

`pine/v2/ARTHA_V2_P17_2_Terminal_Label_Cleanup.pine`
