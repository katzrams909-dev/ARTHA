# ARTHA v2 P08 — Setup Quality Scoring

## Principle

Eligibility and quality are separate systems.

```text
Invalid setup + high confluence = INVALID
Valid setup + low score        = VALID, lower quality
Valid setup + high score       = VALID, higher quality
```

P08 never creates REV or CONT eligibility.

## Score

Maximum: 100.

| Component | Max | Purpose |
|---|---:|---|
| Displacement quality | 30 | Strength of the causal displacement episode |
| Structural quality | 20 | Scope/type of required structural confirmation |
| POI quality | 20 | Native POI type and structural provenance |
| Mitigation condition | 15 | How deeply the POI has already been mitigated |
| Family context | 15 | REV liquidity importance or CONT trend alignment |

## Displacement — 30

The displacement episode peak score is normalized to 30 points.

This preserves the already validated P02 quality model rather than inventing a second displacement metric.

## Structural quality — 20

REV:

- external MSS: 20
- external CHoCH: 18
- internal MSS: 15
- internal CHoCH: 13

CONT:

- external BOS: 20
- internal BOS: 15
- BOS-disabled research mode: 10

## POI quality — 20

Default ordinal weighting:

- OB / BB: 20
- structurally linked FVG: 18
- structurally linked IFVG: 18
- IFVG without structural provenance: 16
- FVG without structural provenance: 14

This is a quality ranking, not a claim that one POI type is universally more profitable.

## Mitigation — 15

Uses the native source engine's maximum mitigation record:

- <=25%: 15
- <=50%: 13
- <=75%: 9
- <100%: 5
- 100%: 0

## Family context — 15

REV uses the liquidity tier that initiated the setup:

- Tier 1: 15
- Tier 2: 12
- Tier 3: 8
- Tier 4: 4

CONT uses trend alignment captured at the impulse:

- internal + external aligned: 15
- valid external trend without full internal alignment: 11

## Grades

Defaults:

- A: >=85
- B: >=75
- C: >=65
- D: <65

Thresholds are configurable.

Grades are display/ranking metadata only.

## Diagnostics

Breakdown notation:

```text
D = displacement
S = structure
P = POI
M = mitigation
C = context
```

Example:

`D24 S20 P18 M13 C15`

## Non-goals

P08 does not add:

- minimum score gate
- trade signal
- entry
- stop
- target
- risk sizing
- performance probability

The score must be calibrated later against observed setup outcomes before any threshold is treated as predictive.
