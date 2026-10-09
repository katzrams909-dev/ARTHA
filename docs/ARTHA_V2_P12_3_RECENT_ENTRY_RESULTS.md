# ARTHA v2 P12.3 — Recent Entry Results

## Objective

Keep the latest completed ARTHA entries visible after their active risk-plan drawings are cleaned up.

## Active trade

The newest active plan continues to show:

- ENTRY
- SL
- T1
- T2

## Completed trade history

When a plan becomes terminal, P12.3 creates a compact result label anchored at the original signal/entry bar.

Default history depth: 4.

Example:

```text
CONT BUY · Q82 B
ENTRY 1.16842
T2 HIT · +2.00R
```

or:

```text
REV SELL · Q76 B
ENTRY 1.34120
STOPPED · -1.00R
```

Expired plans are also identified but do not show fabricated realized R.

## Visual policy

- recent completed entry results: ON by default;
- keep 4 by default, configurable 1–10;
- old result labels are explicitly deleted;
- compact execution arrows are OFF by default because the result labels provide more useful historical context;
- Analysis/Full verbose signal labels remain available.

## Logic

No eligibility, signal, stop, target, or outcome calculations are changed.
