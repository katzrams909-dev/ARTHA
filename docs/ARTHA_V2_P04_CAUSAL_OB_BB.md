# ARTHA v2 P04 — Causal Order Block / Breaker Block

## Objective

Replace v1.x nearest-opposite-candle OB detection with a causal institutional-origin model.

## Qualification chain

A production Order Block requires:

```text
Displacement episode
        ↓
Structure break during that episode
        ↓
Primary structural FVG from the same episode
        ↓
Nearest opposite origin candle immediately before episode start
        ↓
Qualified OB
```

By default, no displacement-only OB is allowed.

## Bullish OB

For a bullish structural episode:

1. episode direction is bullish;
2. episode produced a structure break;
3. a primary structural bullish FVG is linked to that episode;
4. search backward from the episode start;
5. select the nearest bearish candle within the configured search depth;
6. its wick range, or body if configured, defines the bullish OB.

Bearish OB is symmetric.

## Provenance

Each OB stores:

- OB ID
- original direction
- origin candle bar
- zone top/bottom
- episode ID
- primary FVG ID
- displacement peak score
- structure scope
- structure kind
- mitigation depth
- lifecycle state

The episode ID is the central causal key shared with the FVG family.

## Duplicate suppression

Only one OB of a direction may be created for a given displacement episode.

This prevents multiple FVGs from generating duplicate blocks from the same impulse.

## Breaker lifecycle

A Breaker is not independently detected.

```text
ACTIVE OB
    ↓ confirmed failure through far boundary
    + opposite qualified displacement (default)
ACTIVE BB
    ↓ invalidation / configured full traversal
RETIRED
```

Thus:

- failed bullish OB → bearish BB
- failed bearish OB → bullish BB

The same zone geometry and provenance are preserved.

## Mitigation

Zone overlap is tracked as maximum mitigation percentage. Mitigation is metadata only in P04.

## Display

OB/BB text is rendered inside the box.

Optional provenance:

```text
OB · EP42 · FVG17 · MSS
BB · EP42 · FVG17 · MSS
```

## Explicit exclusions

P04 adds no:

- entry signal
- REV/CONT state machine
- setup score
- Premium/Discount filtering
- HTF bias
- risk projection
