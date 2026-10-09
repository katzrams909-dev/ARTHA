# ARTHA v2 P15 — Production Consolidation

## Status

P15 is a production-stabilization pass built directly from the validated P14 baseline.

It does **not** change trading logic.

## Frozen execution model

```text
Structure
→ Liquidity
→ Relative Displacement
→ Episodes
→ FVG / IFVG
→ Causal OB / BB
→ Unified POI
→ REV / CONT
→ Quality
→ NORMAL / MISS / EARLY
→ Conflict resolution
→ Risk / Targets
→ Outcome tracking
```

Signal priority remains:

```text
NORMAL > MISS > EARLY
```

RAW reactions remain ignored.

P13 target-quality rules remain unchanged.

## Removed / consolidated

### Duplicate reaction alert

The generic reaction alert has been removed.

Promoted MISS and EARLY entries already become REV or CONT execution signals, so emitting both a reaction alert and a family execution alert created duplicate notifications.

The retained execution alerts are:

- BUY REV
- SELL REV
- BUY CONT
- SELL CONT

Risk-plan and terminal-outcome alerts remain.

### Terminology

Input group 14 is now **Reaction Entries**, not an audit/adaptive-research layer.

## Resource budgets

Production defaults are reduced to leave more headroom beneath TradingView object limits.

| Resource | P14 default | P15 default |
| --- | ---: | ---: |
| Structure visuals | 100 | 60 |
| Liquidity records | 180 | 120 |
| Displacement markers | 80 | 40 |
| Imbalance zones | 40 | 30 |
| OB/BB zones | 30 | 24 |
| REV eligibility markers | 40 | 25 |
| CONT eligibility markers | 40 | 25 |
| Signal markers | 50 | 30 |

These are display/storage budgets only. They do not alter qualification logic.

Internal risk plans remain 20 by default.
Recent entry/result cards remain 4 by default.

## Signal history

Signal provenance retention is reduced from 200 to 120 records.

This remains substantially deeper than the visible history and is used for duplicate/provenance lookup.

## Display contract

All display controls remain presentation-only.

```text
Display toggle OFF
≠
engine calculation OFF
```

Execution mode remains the production default.

Analysis and Full modes remain available for inspection.

## Deliberately excluded

ARTHA v2 does not include:

- VWAP
- strategy() conversion
- standalone divergence family
- new context engines

The production model stays causal and price/liquidity driven.
