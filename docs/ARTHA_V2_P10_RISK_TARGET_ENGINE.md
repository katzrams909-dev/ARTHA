# ARTHA v2 P10 — Risk & Target Engine

## Objective

Attach a deterministic risk/target plan to each emitted P09 signal.

P10 is downstream only:

```text
Eligible setup
→ quality score
→ P09 signal
→ P10 risk/target plan
```

A poor R:R does not remove the signal in P10.

## Entry

Entry reference is the confirmed P09 signal-bar close.

P10 does not simulate limit orders or intrabar fills.

## Stop models

### Causal — default

REV:

```text
Bull: below the lower of sweep level and POI
Bear: above the higher of sweep level and POI
```

CONT:

```text
Bull: below the lower of protected external low and POI
Bear: above the higher of protected external high and POI
```

An ATR buffer is added outside the structural level.

### POI edge

Uses only the far edge of the bound POI plus buffer.

### Protected swing

Uses the current protected external swing plus buffer, with POI fallback when unavailable.

If a derived stop is accidentally on the wrong side of entry, P10 uses a defensive ATR fallback rather than emitting invalid risk geometry.

## Targets

When active-liquidity targeting is enabled:

Bull:
- nearest active buy-side liquidity above entry = T1
- second-nearest active buy-side liquidity = T2

Bear:
- nearest active sell-side liquidity below entry = T1
- second-nearest active sell-side liquidity = T2

If a liquidity target is unavailable, P10 uses configurable R fallbacks.

Defaults:

- T1 fallback: 1.5R
- T2 fallback: 2.5R

## Output

Each plan stores:

- family
- direction
- episode ID
- POI identity
- signal bar/time
- entry
- stop
- target 1
- target 2
- projected R:R to each target
- whether each target came from liquidity or R fallback

## Visual lifecycle

Risk-plan lines use time coordinates and extend right.

The visible plan registry is bounded by `Maximum visible risk plans`. Old plan objects are explicitly deleted.

## Non-goals

P10 does not:

- size positions
- execute orders
- calculate account risk
- move stops
- track realized trade outcome
- filter P09 signals by R:R

Those functions should be evaluated only after risk geometry is validated.
