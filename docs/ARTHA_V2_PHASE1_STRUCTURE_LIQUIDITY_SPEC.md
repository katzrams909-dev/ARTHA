# ARTHA v2 — Phase 1 Structure + Liquidity Specification

## Status

- Branch: `artha-v2-revaluation`
- Baseline preserved: `master/ARTHA_MASTER_v1_7_1_OB_BB_TriggerRepair.pine`
- Purpose: rebuild the authoritative market-state primitives before any v2 signal logic is added.
- Scope: Structure Engine + Liquidity Engine only.
- Out of scope for this phase: FVG/IFVG, OB/BB, VWAP, divergence, scoring, risk projection, entry signals.

---

## 1. Core Design Rule

ARTHA v2 is event-driven.

```text
MARKET STATE
    ↓
LIQUIDITY MAP
    ↓
LIQUIDITY EVENT
    ↓
DISPLACEMENT
    ↓
STRUCTURE RESPONSE
    ↓
POI
    ↓
SETUP
```

Phase 1 supplies only the first two authoritative layers:

```text
Structure Engine
Liquidity Engine
```

No renderer, filter, scoring rule, or future signal engine may redefine structure or liquidity independently.

---

## 2. Non-Repainting Contract

All committed states must obey these rules:

1. Only confirmed bars may commit structure breaks, liquidity sweeps, resolutions, or lifecycle transitions.
2. Pivots may be visually anchored to their true pivot bar, but may only enter engine state on the bar where the pivot is confirmed.
3. Higher-timeframe logic added later must use confirmed HTF data only.
4. Reloading the chart must not change any historical committed structure or liquidity event.
5. Display inputs must never disable engine calculations.
6. Diagnostics are read-only.
7. A lifecycle object may change state forward in time, but a past committed event must not be reclassified retroactively.

---

## 3. Shared Event Model

All engines should communicate through normalized event/state fields rather than ad-hoc booleans.

### Structure event

```text
StructureEvent
    id
    scope              INTERNAL | EXTERNAL
    direction          BULL | BEAR
    kind               BOS | CHOCH | MSS
    brokenPrice
    pivotBar
    confirmationBar
    displacementScore
    priorTrend
    resultingTrend
```

### Swing record

```text
SwingPoint
    id
    scope              INTERNAL | EXTERNAL
    side               HIGH | LOW
    price
    pivotBar
    confirmationBar
    classification     HH | HL | LH | LL
    protected          bool
    broken             bool
```

### Liquidity record

```text
LiquidityLevel
    id
    sourceType
    sourceName
    side               BUY_SIDE | SELL_SIDE
    price
    tier               1..4
    state              ACTIVE | SWEPT | RESOLVED | EXPIRED | SUPERSEDED
    createdBar
    terminalBar
    originSwingId
    clusterCount
    expiryBar
```

---

## 4. Structure Engine

### 4.1 One structure model

The same conceptual structure engine must eventually be reusable on:

- Execution timeframe
- MTF
- HTF

ARTHA v2 must not maintain a separate simplified bias algorithm that disagrees with chart structure.

### 4.2 Pivot layers

Two confirmed pivot layers remain:

- Internal pivot strength
- External pivot strength

The strengths remain configurable, but the engine must treat them as different structural scopes rather than merely different visual lengths.

### 4.3 Swing classification

Each confirmed swing is classified against the prior confirmed swing of the same side and scope:

- High > prior high → HH
- High <= prior high → LH
- Low > prior low → HL
- Low <= prior low → LL

Classification is descriptive only. It does not itself create BOS/CHoCH/MSS.

### 4.4 Structure targets

A swing becomes a break target only after pivot confirmation.

For each scope track:

- active target high
- active target low
- protected high
- protected low
- current structural trend

### 4.5 Break confirmation

Configurable rule:

- Close through structure — default
- Wick through structure — optional diagnostic/legacy mode

Production v2 should default to close confirmation.

### 4.6 BOS / CHoCH / MSS semantics

#### BOS

Continuation break in the direction of the current structure trend.

```text
Bullish trend + confirmed break above active high → Bull BOS
Bearish trend + confirmed break below active low → Bear BOS
```

#### CHoCH

First confirmed break against the current structure trend when displacement quality is insufficient for MSS.

#### MSS

First confirmed break against the current structure trend with qualified displacement.

Important:

```text
MSS = structural transition + qualified displacement
```

not:

```text
large candle = MSS
```

The break is structurally primary; displacement upgrades CHoCH to MSS.

### 4.7 Displacement handoff contract

Phase 1 will expose the break event and the body/range measurements required by the future Displacement Engine.

Temporary Phase 1 MSS qualification may still use ATR body size for parity testing, but this must be isolated behind one helper so Phase 2 can replace it without rewriting structure state.

### 4.8 Protected swings

When bullish structure is confirmed:

- the relevant confirmed low becomes protected low.

When bearish structure is confirmed:

- the relevant confirmed high becomes protected high.

Protected swings are first-class state and must be available to:

- continuation logic
- invalidation logic
- dealing-range construction
- liquidity importance
- future HTF context

### 4.9 Structure state values

Each scope outputs:

```text
trend = -1 bearish | 0 neutral | +1 bullish
lastEvent = BOS | CHOCH | MSS | NONE
lastEventDirection
lastEventBar
protectedHigh
protectedLow
activeTargetHigh
activeTargetLow
```

---

## 5. Liquidity Engine

### 5.1 Liquidity is not one flat list

Each liquidity level receives a source type and importance tier.

Default hierarchy:

| Tier | Liquidity type |
|---|---|
| 1 | PMH/PML, PWH/PWL |
| 2 | PDH/PDL, confirmed external swing liquidity |
| 3 | completed session H/L, EQH/EQL cluster |
| 4 | internal swing liquidity |

The tier is metadata. Future setup rules may choose minimum tiers, but Phase 1 must not hard-code trade eligibility.

### 5.2 Source types

Required Phase 1 source types:

```text
PREVIOUS_MONTH
PREVIOUS_WEEK
PREVIOUS_DAY
EXTERNAL_SWING
INTERNAL_SWING
EQUAL_HIGH
EQUAL_LOW
```

Sessions are deferred to the session phase, but the liquidity API must support them later without redesign.

### 5.3 D/W/M reference liquidity

Use confirmed previous periods:

- PMH/PML
- PWH/PWL
- PDH/PDL

On new period:

1. supersede prior active record for that source;
2. create the new previous-period level;
3. preserve the terminal history state.

### 5.4 Swing liquidity

Every eligible confirmed swing may create liquidity.

Rules:

- External swings are higher priority than internal swings.
- Duplicate levels within tolerance are clustered rather than blindly duplicated.
- A level already represented by a stronger source should not produce a redundant same-price lower-tier visual record.
- Engine state should still preserve source provenance where useful.

### 5.5 EQH / EQL clustering

Tolerance:

```text
abs(priceA - priceB) <= ATR * eqTolerance
```

A cluster requires at least two separately confirmed swings.

Cluster record must store:

- representative price
- count
- first swing
- latest swing
- tier
- side

A cluster becomes stronger as count increases, but Phase 1 should expose count rather than convert it directly into signal score.

### 5.6 Duplicate suppression

The v1.7.1 stub:

```pine
f_hasActiveSwingNear(...) => false
```

must not survive v2.

Duplicate handling rules:

1. Search active levels on same side within tolerance.
2. If a same-type/same-tier level exists, update/cluster instead of adding another object.
3. If a stronger-tier level exists at the same price region, preserve the stronger level as the main liquidity record.
4. If a weaker level later gains independent cluster evidence, update metadata rather than draw overlapping duplicate lines.

### 5.7 Liquidity lifecycle

State machine:

```text
ACTIVE
 ├─ wick through + close back inside → SWEPT
 ├─ close through → RESOLVED
 ├─ age expiry → EXPIRED
 └─ replaced by newer same reference source → SUPERSEDED
```

### 5.8 Sweep semantics

Buy-side liquidity:

```text
high > level
AND close < level
→ bearish sweep event
```

Sell-side liquidity:

```text
low < level
AND close > level
→ bullish sweep event
```

Only confirmed bars commit sweep events.

### 5.9 Resolution semantics

Buy-side:

```text
close > level
→ resolved upward
```

Sell-side:

```text
close < level
→ resolved downward
```

Resolution is not the same as a sweep.

Future REV logic should default to sweep origins only; future continuation logic may use resolution as context.

### 5.10 Event payload

On every terminal transition expose:

```text
liquidityEvent
    levelId
    sourceType
    sourceName
    side
    tier
    price
    eventType           SWEEP | RESOLUTION | EXPIRY | SUPERSEDE
    confirmationBar
```

This replaces string-only dependencies such as checking whether a source equals `"PDL"`.

---

## 6. Structure–Liquidity Interaction

Phase 1 must expose relationships without generating trade signals.

Examples:

- external swing creates a Tier-2 liquidity level;
- that level is swept;
- a later opposing structure shift can reference the swept level ID;
- a future setup engine can know exactly which liquidity event preceded the shift.

Required event memory:

```text
latestBullishLiquidityEvent
latestBearishLiquidityEvent
latestBullishStructureEvent
latestBearishStructureEvent
```

Do not collapse these into one `latestSweepSource` string.

---

## 7. Visualization Contract

Visualization must consume engine state.

Structure:

- BOS/CHoCH/MSS line + text
- optional internal/external toggles

Liquidity:

- active levels extend only while active;
- terminal levels stop at terminal bar;
- optional display of swept/resolved history;
- labels use source name and optional tier;
- no line may extend indefinitely after terminal state.

Display modes must never change calculations.

---

## 8. Diagnostics

Phase 1 diagnostic panel should expose at minimum:

### Structure

- internal trend
- external trend
- active internal target high/low
- active external target high/low
- protected high/low
- last internal event
- last external event

### Liquidity

- active level count by tier
- last sweep source / tier / side
- last resolution source / tier / side
- EQH count
- EQL count
- duplicate suppressions
- expired count
- superseded count

Diagnostics are read-only.

---

## 9. Acceptance Tests

### Structure tests

1. Confirmed pivots do not appear in engine state before confirmation.
2. BOS does not repaint after reload.
3. CHoCH/MSS occurs only on an actual opposing structural break.
4. MSS qualification can be changed in one isolated helper.
5. Protected swings update only after committed structure events.
6. Internal and external scopes remain independent.

### D/W/M liquidity tests

1. PDH/PDL always represent the immediately previous completed day.
2. PWH/PWL represent the immediately previous completed week.
3. PMH/PML represent the immediately previous completed month.
4. Prior reference lines stop when superseded.
5. Swept/resolved levels stop at terminal event.

### Swing liquidity tests

1. External swing levels are created on pivot confirmation.
2. Internal swing levels are created on pivot confirmation.
3. Duplicate nearby swings cluster rather than create overlapping records.
4. Equal highs/lows require at least two confirmed swings.
5. A sweep cannot be committed intrabar and later disappear.
6. Close-through is RESOLVED, not SWEPT.

### Reload test

Historical structure and liquidity state must reproduce identically after chart reload.

---

## 10. Migration From v1.7.1

### Preserve conceptually

- confirmed internal/external pivots
- BOS/CHoCH/MSS event separation
- previous D/W/M reference handling
- explicit liquidity terminal states
- non-repainting confirmed-bar policy
- display/calculation separation

### Replace

- `f_hasActiveSwingNear(...) => false`
- string-only liquidity origin checks
- flat liquidity importance
- duplicated HTF structure logic later
- structure/displacement coupling spread across the script

### Defer

- FVG/IFVG
- OB/BB
- Premium/Discount
- HTF/MTF execution
- Sessions
- VWAP
- Divergence
- Scoring
- REV/CONT
- Risk
- Dashboard

---

## 11. Phase 1 Deliverables

1. This specification.
2. A compile-safe Pine Script v6 prototype containing:
   - shared types;
   - confirmed internal/external structure;
   - protected swings;
   - D/W/M liquidity;
   - swing liquidity;
   - EQH/EQL clustering;
   - lifecycle states;
   - basic diagnostics.
3. No signal-generation code.
4. Test checklist for visual/reload verification.

---

## 12. Phase 1 Exit Criteria

Phase 1 is complete only when:

- Structure events are stable and visually correct.
- Liquidity lines terminate correctly.
- Previous period levels are correct.
- Swing liquidity duplicate suppression works.
- EQH/EQL clustering works.
- Sweep versus resolution is correctly distinguished.
- Reload does not alter historical events.
- No signal logic exists in the prototype.
- The prototype compiles in Pine Script v6.

Only after those conditions are satisfied should ARTHA v2 proceed to the Displacement + POI phases.
