# ARTHA v2 — Production Architecture

## Purpose

ARTHA v2 is a non-repainting TradingView indicator built around a causal institutional-price-action model.

The production pipeline is:

```text
Market structure
→ Liquidity
→ Relative displacement
→ Displacement episodes
→ FVG / IFVG
→ Causal OB / BB
→ Unified POI
→ REV / CONT setup eligibility
→ Quality scoring
→ NORMAL / MISS / EARLY execution signals
→ Signal conflict resolution
→ Risk / targets
→ Outcome tracking
```

The governing design rule is:

> Confluence ranks a valid setup; it does not create a setup.

## 1. Structure

ARTHA tracks confirmed internal and external pivots.

Outputs include:

- HH / HL / LH / LL;
- BOS;
- CHoCH;
- MSS;
- protected highs and lows.

Structure is confirmed-bar and causal.

## 2. Liquidity

Tracked liquidity includes:

- previous month high/low;
- previous week high/low;
- previous day high/low;
- external swing liquidity;
- internal swing liquidity;
- EQH / EQL clusters.

Hierarchy:

```text
Tier 1: PMH/PML, PWH/PWL
Tier 2: PDH/PDL, external swings
Tier 3: EQH/EQL
Tier 4: internal swings
```

Lifecycle:

```text
ACTIVE
→ SWEPT
→ RESOLVED / EXPIRED / SUPERSEDED
```

## 3. Relative displacement

Displacement is qualified relative to recent candles rather than by an isolated absolute threshold.

Core measurements include:

- body / ATR;
- range / ATR;
- body efficiency;
- directional close location;
- body vs recent average;
- range vs recent average;
- optional volume context;
- follow-through.

## 4. Displacement episodes

Related same-direction displacement bars are aggregated into one causal episode.

Default episode logic:

```text
same direction
+ max 1 non-DSP gap
+ max 8 bars
= one episode
```

Episodes retain:

- direction;
- start / end;
- peak displacement bar;
- peak score;
- event count;
- structure-break provenance.

## 5. FVG / IFVG

Three-candle imbalance geometry:

```text
Bull FVG: low > high[2]
Bear FVG: high < low[2]
```

IFVG is not a separate setup family. It is the same imbalance object after confirmed directional failure/inversion.

Primary FVG family members are ranked by episode provenance.

## 6. Causal OB / BB

Order Blocks require a causal chain:

```text
displacement episode
→ structure break
→ primary structural FVG
→ nearest opposite origin candle
→ OB
```

Breaker Blocks are lifecycle transitions of qualified OBs after confirmed failure.

## 7. Unified POI registry

FVG, IFVG, OB and BB are normalized into one POI schema.

The setup engines consume Unified POIs rather than maintaining separate execution logic for each POI type.

## 8. Setup families

ARTHA v2 has only two setup families:

### REV

```text
liquidity sweep
→ displacement
→ CHoCH/MSS
→ same-episode primary POI
→ retest
→ reaction
→ eligible
```

BOS alone does not qualify a reversal.

### CONT

```text
pre-existing trend
→ same-direction displacement
→ same-direction BOS
→ same-episode primary POI
→ pullback
→ reaction
→ eligible
```

## 9. Quality scoring

Post-eligibility score:

```text
30 displacement
20 structure
20 POI
15 mitigation
15 family context
= 100
```

Grades:

```text
A ≥ 85
B 75–84
C 65–74
D < 65
```

Quality ranks valid setups. It does not manufacture eligibility.

## 10. Signal classes

Production signals:

```text
NORMAL
MISS
EARLY
```

RAW reactions are ignored.

### NORMAL

Standard REV/CONT signal after full eligibility + quality + signal gates.

### MISS

A confirmed reaction that P11.6 identified as a true missed entry. In production it is promoted to a valid execution signal.

### EARLY

A direction-aware early reaction with sufficient recent causal context. In production it is also a valid execution signal.

## 11. EARLY frequency control

Repeated same-direction EARLY signals are suppressed until a reset occurs.

Reset conditions include:

- a new displacement episode;
- a new CHoCH/MSS;
- an opposite-direction execution signal.

## 12. Signal conflict resolution

Priority:

```text
NORMAL = 3
MISS   = 2
EARLY  = 1
```

Within the same-direction conflict window:

- stronger may supersede weaker;
- equal priority is blocked;
- weaker is blocked.

Opposite directions are independent.

## 13. Risk engine

Entry is the confirmed signal-bar close.

Stops are causal and family-aware, with ATR buffer.

Targeting first looks for acceptable opposing liquidity.

Production target filters include:

- active state;
- correct side;
- acceptable liquidity tier;
- minimum R;
- maximum R;
- T1/T2 separation;
- T2 selected only after finalized T1;
- exhaustive search for the nearest valid T2 beyond T1;
- guaranteed fallback T2 beyond T1.

Defaults:

```text
Minimum T1: 0.75R
Minimum T2: 1.50R
Maximum liquidity target: 5.00R
Fallback T1: 1.50R
Fallback T2: 2.50R
```

## 14. Outcome tracking

States:

```text
ACTIVE
→ T1_HIT
→ T2_HIT / STOPPED / EXPIRED
```

Same-bar precedence is conservative: stop before target.

Default outcome model:

```text
50% at T1
+ break-even remainder
```

## 15. Display model

Production default is Execution mode.

- newest active plan: full ENTRY / SL / T1 / T2;
- recent entry/result cards: last 4;
- completed cards: compact;
- Analysis and Full modes remain available.

Visual toggles do not control engine calculations.

## Deliberately excluded

ARTHA v2 production does not include:

- VWAP;
- strategy() conversion;
- standalone divergence setup family;
- additional context engines.

The release stays focused on causal price, structure, liquidity and POI behavior.
