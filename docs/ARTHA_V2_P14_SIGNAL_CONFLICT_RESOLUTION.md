# ARTHA v2 P14 — Signal Conflict Resolution

## Objective

Prevent nearby same-direction NORMAL, MISS and EARLY signals from stacking as if they were unrelated ideas.

## Priority

```text
NORMAL = 3
MISS   = 2
EARLY  = 1
```

The resolver is directional. Bullish and bearish streams are treated independently.

## Conflict window

Default:

```text
6 bars
```

Within that window:

- stronger priority may supersede weaker priority;
- equal priority is blocked;
- weaker priority is blocked.

Outside the window, a new signal may be admitted normally.

## Examples

### EARLY then NORMAL

```text
bar 100: BUY EARLY
bar 102: BUY NORMAL
```

NORMAL is admitted because 3 > 1.

### NORMAL then EARLY

```text
bar 100: BUY NORMAL
bar 102: BUY EARLY
```

EARLY is rejected because 1 < 3.

### MISS then EARLY

EARLY is rejected inside the window.

### EARLY then MISS

MISS is admitted inside the window.

## Same-bar normal-family tie

REV remains evaluated before CONT.

P14 intentionally does not rewrite validated REV/CONT eligibility to perform score-based same-bar family arbitration. That can be revisited only if visual testing shows a real problem.

## Opposite direction

Opposite-direction signals are not blocked by this resolver. They may represent a genuine change in market direction and are also useful as reset information for EARLY frequency control.

## Unchanged

- Structure and liquidity
- displacement / episodes
- FVG / IFVG
- OB / BB
- REV / CONT qualification
- NORMAL / MISS / EARLY qualification
- P13 target-quality rules
- risk and outcome calculation
- recent-entry cards
- VWAP remains excluded
