# ARTHA v2 — Production Validation Status

## Release baseline

Source:

`pine/v2/ARTHA_V2_Production.pine`

Frozen from:

`pine/v2/ARTHA_V2_P15_1_Target_Ordering_Hotfix.pine`

Branch:

`artha-v2-revaluation`

## Validated stages

| Phase | Area | Status |
| --- | --- | --- |
| P01 | Structure + Liquidity | Validated |
| P02.2 | Relative Displacement | Validated |
| P02.3 | Displacement Episodes | Validated |
| P03.2 | Primary FVG Families | Validated |
| P04 | Causal OB / BB | Validated |
| P05 | Unified POI | Validated |
| P06 | Reversal Setup | Validated |
| P07 | Continuation Setup | Validated |
| P08 | Setup Quality | Integrated |
| P09 | Signal Engine | Integrated |
| P10.1 | Risk Lifecycle | Validated |
| P11 | Outcome Tracking | Compile validated |
| P11.2 | Readable Trade Display | Validated |
| P11.6 | Direction-Aware Reaction Audit | Foundation for production reaction signals |
| P12.6 | Lean Reaction Signals | Integrated |
| P12.7 | Signal Frequency + Display Cleanup | Validated |
| P13 | Target Quality | Validated |
| P14 | Signal Conflict Resolution | Validated |
| P15 | Production Consolidation | Validated |
| P15.1 | Target Ordering Hotfix | Compile + visual validated |

## P15.1 production hotfix

The production file now includes the validated P15.1 target-ordering fix:

- T2 is always beyond finalized T1;
- T2 liquidity search is exhaustive beyond finalized T1;
- invalid nearer liquidity cannot hide a later valid T2;
- recent-entry input wording matches active + completed card behavior.

## Current production behavior

Validated production signal classes:

```text
NORMAL
MISS
EARLY
```

RAW reactions do not become signals.

Priority:

```text
NORMAL > MISS > EARLY
```

## Resource behavior

Production defaults are bounded.

Key defaults:

```text
Structure visuals: 60
Liquidity records: 120
Imbalance zones: 30
OB/BB zones: 24
REV markers: 25
CONT markers: 25
Signal markers: 30
Risk plans: 20
Recent result cards: 4
Signal history: 120
```

## Non-repainting contract

Production logic uses confirmed-bar causal events.

The indicator does not intentionally use future bars to qualify setup events.

## Display contract

Visual controls are presentation-only.

Turning off:

- structure;
- liquidity;
- FVG/IFVG;
- OB/BB;
- signal markers;
- risk drawings

must not disable the underlying calculations.

## Final smoke-test checklist

Before merging the production branch to main, repeat a basic chart smoke test on:

- NAS100 5m;
- XAUUSD 5m;
- EURUSD 5m;
- GBPUSD 5m.

Verify:

- normal signals;
- MISS signals;
- EARLY signals;
- conflict priority;
- P13 target limits;
- active plan lifecycle;
- recent result cards;
- no runaway lines/boxes/labels;
- no Pine runtime errors.
