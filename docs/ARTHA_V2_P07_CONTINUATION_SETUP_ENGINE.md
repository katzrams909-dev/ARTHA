# ARTHA v2 P07 — Continuation Setup Engine

## Objective

Add the second and final setup family while preserving the validated REV engine.

CONT is not “active POI + reaction.” It requires an established trend and a fresh same-direction expansion episode.

## Causal chain

```text
Established trend
    ↓
Qualified same-direction displacement
    ↓
Same-direction BOS (default)
    ↓
Same-episode primary Unified POI
    ↓
Pullback / retest
    ↓
Reaction
    ↓
CONT ELIGIBLE
```

No liquidity sweep is required.

## Established trend

Trend must exist before the qualifying impulse.

Default:

```text
External trend already bullish → bullish CONT may form
External trend already bearish → bearish CONT may form
```

Optional strict mode requires internal and external trend alignment.

The state captured before the current structural break is used. Therefore a CHoCH that creates a new trend cannot simultaneously qualify as continuation.

## Expansion event

A continuation impulse requires:

- qualified same-direction displacement;
- active displacement episode of that direction;
- pre-existing same-direction trend;
- no same-direction CHoCH/MSS on the trigger bar;
- same-direction BOS by default.

BOS scope is configurable:

- Any
- External

Same-direction BOS can be disabled for research, but default behavior requires it.

## State model

```text
IDLE
  ↓ trend + expansion/BOS
IMPULSE
  ↓ same-episode primary POI
ARMED
  ↓ pullback into POI
RETEST
  ↓ continuation reaction
ELIGIBLE
```

## POI binding

Only active primary UnifiedPOIs with the same episode ID and current actionable direction may bind.

Preference:

- Nearest
- OB/BB first
- FVG/IFVG first

This is selection among already valid POIs only.

## Reaction

Same modes as REV:

- Directional close
- Midpoint reclaim (default)

## Invalidation

Candidate resets when:

- impulse-to-POI window expires;
- POI-to-pullback window expires;
- POI retires/disappears;
- POI inverts;
- required trend is lost;
- opposite CHoCH/MSS occurs when enabled.

## REV vs CONT separation

```text
REV:
liquidity sweep → reversal shift (CHoCH/MSS) → POI → retest → reaction

CONT:
pre-existing trend → continuation expansion/BOS → POI → pullback → reaction
```

A CHoCH/MSS cannot be the qualifying CONT structure event.

## Explicit exclusions

P07 still adds no:

- setup quality score
- entry price
- stop loss
- targets
- trade signal
- alert recommendation
