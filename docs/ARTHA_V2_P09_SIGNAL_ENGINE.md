# ARTHA v2 P09 — Signal Engine

## Objective

Convert an already eligible, already scored REV or CONT setup into a discrete execution signal.

The architecture is intentionally separated:

```text
Setup eligibility
    ↓
Quality score
    ↓
Signal filter
    ↓
Execution signal
```

A rejected signal does not invalidate the underlying setup.

## Default signal rules

REV signal:

```text
REV Eligible
AND quality >= 75
AND no duplicate family+episode+POI signal
AND directional cooldown satisfied
```

CONT uses the same structure with its own configurable score threshold.

Defaults:

- REV threshold: 75
- CONT threshold: 75
- cooldown: 3 bars
- one signal per family + episode + POI: enabled

## Duplicate identity

Signal identity is:

```text
setup family
+ episode ID
+ source engine
+ source POI ID
```

REV and CONT remain distinct families even when they reference the same native POI.

## Cooldown

Cooldown is directional.

A recent bullish signal can suppress another bullish signal during the configured window without suppressing a bearish signal.

This is an execution-noise control, not setup logic.

## Signal outputs

Four discrete engine events:

- BUY REV
- SELL REV
- BUY CONT
- SELL CONT

Markers display family and quality:

`BUY REV · Q84 B`

## Diagnostics

P09 records:

- bullish / bearish signal counts
- REV / CONT signal counts
- rejected by quality
- rejected as duplicate
- rejected by cooldown
- last emitted signal

## Important contract

Changing a P09 signal threshold must not change:

- REV eligible count
- CONT eligible count
- setup quality score
- setup grade

P09 operates only after those systems finish.

## Non-goals

P09 does not yet define:

- stop loss
- target
- position size
- risk-reward
- trade outcome
- strategy/backtest order execution

Those belong to the next risk/target layer.
