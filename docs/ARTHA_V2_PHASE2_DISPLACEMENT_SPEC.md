# ARTHA v2 — Phase 2 Displacement Specification

## Objective

Replace the Phase 1 temporary MSS body/ATR test with a dedicated, directional displacement engine. Displacement is an event and quality measurement, not a trade signal and not a POI.

## Causal role

```text
Liquidity event
→ Displacement
→ Structure response
→ later POI formation
```

A large candle alone does not create a setup.

## Measurements

For each confirmed directional candle:

- body / ATR
- total range / ATR
- body efficiency = body / total candle range
- directional close location
- immediate directional follow-through
- optional relative-volume expansion

Bullish close location:

`(close - low) / (high - low)`

Bearish close location:

`(high - close) / (high - low)`

## Quality score

Default 100-point framework:

| Component | Max |
|---|---:|
| Body expansion | 30 |
| Range expansion | 20 |
| Body efficiency | 20 |
| Close location | 20 |
| Follow-through | 5 |
| Optional volume expansion | 5 |

The score describes impulse quality. It must not independently create a trade.

## Qualification modes

### Body only
Legacy-compatible diagnostic mode. Requires direction + minimum body/ATR.

### Balanced — default
Requires direction, minimum body expansion, and minimum quality score.

### Strict
Requires direction plus all minimum body, range, efficiency, close-location, and score thresholds.

## Structure integration

CHoCH remains an opposing structural break without qualified displacement.

MSS becomes:

```text
opposing structural break
+
qualified same-direction displacement event
```

Thus displacement upgrades a structural transition to MSS; it does not substitute for the structural break.

## Event payload

Each committed event stores:

- ID
- direction
- bar
- quality score
- body/ATR
- range/ATR
- body efficiency
- close location
- follow-through flag
- volume-expansion flag
- whether the bar also broke structure
- structure scope
- structure event kind

## Non-repainting

Only confirmed bars create displacement events. Historical event scores and classifications must remain identical after reload.

## Explicit exclusions

P02 contains no:

- FVG/IFVG qualification
- OB/BB creation
- REV/CONT setup state
- signal score
- risk engine
- trade signal

FVG generation may later be recorded as downstream evidence of displacement, but is not part of displacement's definition.
