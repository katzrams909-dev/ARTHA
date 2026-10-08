# ARTHA v2 P11.1 — Clean Trade Display

## Purpose

P11 outcome tracking was functional but chart text around the active plan was too dense.

P11.1 changes presentation only.

## Active plan display

Each visible plan now uses four compact right-edge tags:

```text
E
SL
T1
T2
```

The long inline sentence at entry is removed.

A separate compact status tag shows:

```text
CONT BUY · ACTIVE · R1 1.50 · R2 2.50
```

or after first target:

```text
CONT BUY · T1 HIT · R1 1.50 · R2 2.50
```

## Controls

- Show E / SL / T1 / T2 tags
- Show active plan status tag
- Show terminal outcome labels

Terminal outcome labels remain off by default.

## Chart policy

Detailed prices, R metrics, win rate, and realized-R accounting remain in diagnostics.

The chart itself should answer only:

- where is entry?
- where is invalidation?
- where are T1 and T2?
- what family/direction is active?
- has T1 been reached?

No calculation or signal logic is changed from P11.
