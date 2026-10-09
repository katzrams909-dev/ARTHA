# ARTHA v2 P12.6 — Lean Reaction Signals

## Reset point

P12.6 is the new baseline built from the clean P11.6 reaction classifier and the useful P12 production behavior.

The patch chain after P12 is intentionally not carried forward wholesale.

## What remains

Core execution stack:

```text
Structure
→ Liquidity
→ Displacement
→ Episodes
→ FVG / IFVG
→ OB / BB
→ Unified POI
→ REV / CONT
→ Quality
→ Signals
→ Risk / Targets
→ Outcomes
```

## Signal paths

```text
NORMAL ARTHA
→ execution signal

TRUE_MISS
→ MISS execution signal

EARLY
→ EARLY execution signal

RAW
→ ignored
```

### MISS

Former P11.6 TRUE_MISS events are now valid signals when the reaction confirms, the family is enabled, the setup/POI provenance is valid, and duplicate/cooldown gates pass.

### EARLY

Former P11.6 EARLY opportunities are now valid signals when their direction-aware recent REV/CONT context is valid, the POI reaction confirms, and duplicate/cooldown gates pass.

EARLY uses its own minimum quality threshold, default 65.

### RAW

RAW POI reactions produce no signal, marker, risk plan, or alert.

## Removed

The lean production path removes:

- Research/Production runtime-profile switching;
- orange missed-entry labels;
- orange early-opportunity triangles;
- RAW reaction display;
- the large diagnostic table;
- duplicate terminal outcome-label system.

## Recent entry/result display

The useful P12 display model remains:

- newest active plan: ENTRY / SL / T1 / T2;
- recent entry cards: ON by default;
- keep last 4 cards by default;
- cards update through ACTIVE → T1 HIT → T2 HIT / STOPPED / EXPIRED.

Reaction-derived cards are explicitly tagged:

```text
REV BUY · MISS
CONT SELL · EARLY
```

Normal entries have no extra source tag.

## Risk-plan tracking

Visible cards and internal tracking are separate.

- visible recent entries: 4 default;
- internally tracked risk plans: 20 default.

This prevents a trade from disappearing from tracking merely because it is no longer one of the four visible entries.

## Important

P12.6 is a behavioral reset: MISS and EARLY are now part of the execution-signal model, not audit-only observations.
