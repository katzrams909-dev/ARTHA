# ARTHA v2 P17.3 — Risk Line Cleanup

## Purpose

Prevent completed or expired trades from leaving orphaned entry, stop-loss, and take-profit lines without context.

## Behavior

When a RiskPlan reaches a terminal state (`T2_HIT`, `STOPPED`, or `EXPIRED`), the script deletes its:
- entry line;
- stop-loss line;
- T1 line;
- T2 line;
- remaining per-trade text labels.

This cleanup is unconditional. There is no longer a setting to retain terminal risk-plan lines, because the intended chart behavior is to remove those unlabeled lines.

The separate recent-entry result card remains visible according to the existing history setting. Active trade plans retain their lines and labels.

## Unchanged

- P17 calibration presets;
- signal eligibility and generation;
- entry, stop, and target prices;
- outcome calculations and attribution;
- recent entry/result cards;
- active trade drawings.

## Validation target

`pine/v2/ARTHA_V2_P17_3_Risk_Line_Cleanup.pine`
