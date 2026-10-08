# ARTHA v2 P06 — Reversal Setup Engine

## Objective

Implement the first setup-family state machine without adding scoring or trade signals.

A REV setup must be causally complete before it is eligible:

```text
Liquidity sweep
    ↓
Qualified same-direction displacement
    ↓
Reversal structural shift (CHoCH/MSS)
    ↓
Same-episode Unified POI
    ↓
Retest
    ↓
Reaction
    ↓
REV ELIGIBLE
```

Confluence cannot create a REV setup.

## Direction

Bullish REV begins with a sell-side liquidity sweep.

Bearish REV begins with a buy-side liquidity sweep.

## State model

```text
IDLE
  ↓ liquidity sweep
SWEEP
  ↓ displacement + CHoCH/MSS
SHIFT
  ↓ same-episode Unified POI
ARMED
  ↓ POI retest
RETEST
  ↓ reaction confirmation
ELIGIBLE
```

Eligibility is a one-bar engine event. The candidate returns to IDLE on the next confirmed bar unless a new sweep replaces it.

## Structural shift

The structural shift must occur on a qualified displacement bar.

Configurable scope:

- Any: internal or external CHoCH/MSS
- External: external CHoCH/MSS only

A same-direction BOS is not sufficient for REV qualification.

## POI binding

REV only accepts an active UnifiedPOI with:

- same displacement episode ID;
- same actionable direction;
- primary=true.

POI preference is configurable:

- Nearest
- OB/BB first
- FVG/IFVG first

Preference selects among already valid POIs. It does not create validity.

## Retest

A retest occurs after the POI is armed when price overlaps the POI range.

The creation/arming bar cannot count as the retest.

## Reaction

Modes:

### Directional close
Bull: bullish candle.
Bear: bearish candle.

### Midpoint reclaim — default
Bull: bullish candle closing above POI midpoint.
Bear: bearish candle closing below POI midpoint.

## Invalidation

A candidate is invalidated when:

- sweep-to-shift window expires;
- shift-to-POI window expires;
- POI-to-retest window expires;
- bound POI retires/disappears;
- bound POI inverts direction;
- opposite structure break occurs when enabled.

## Non-repainting

All transitions use confirmed source-engine events.

No score, entry, stop, target, or trade recommendation is produced in P06.
