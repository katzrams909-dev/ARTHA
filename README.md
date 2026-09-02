# ARTHA

# TradingView Institutional-Style Indicator — Project Handoff Summary

This document captures the **core design decisions, logic, architecture, constraints, and development sequence** established in this discussion. The purpose is to allow a new chat to continue directly into **engine development and indicator implementation**, without restarting the brainstorming phase.

---

# 1. Project Objective

Build a **non-repainting TradingView indicator in Pine Script v6** inspired by concepts used in institutional/SMC-style trading models, including ideas associated with LuxAlgo and the IFVG model discussed by PJ Trades.

The indicator should not simply stack conventional indicators.

The intended philosophy is:

> **Market context → liquidity event → displacement → structural confirmation → POI → retest → signal.**

The system should identify **causal sequences**, rather than generate a trade merely because several unrelated conditions happen to be true.

The indicator should be:

* non-repainting
* modular
* computationally efficient
* configurable
* visually clean
* capable of detailed diagnostic/debug output
* resistant to duplicate signals
* designed around state machines rather than independent Boolean conditions
* expandable without having to rewrite the core engine

---

# 2. Major Components Requested

The overall indicator is intended to eventually contain:

1. **FVG**
2. **IFVG**
3. **Order Blocks**
4. **Breaker Blocks**
5. **Market Structure**

   * BOS
   * CHoCH
   * MSS
   * HH
   * HL
   * LH
   * LL
6. **Liquidity**
7. **Previous Day High/Low**
8. **Previous Week High/Low**
9. **Previous Month High/Low**
10. **Session High/Low**

    * Asia
    * London
    * New York
11. **Premium/Discount**
12. **HTF Bias**
13. **MTF Bias**
14. **Divergence**

    * SMT
    * RSI/momentum divergence
15. **VWAP**

    * Session
    * Daily
    * Weekly
    * Monthly
16. **Signal generation**
17. **Signal grading**
18. **Alerts**
19. **Clean-chart visualization**
20. **Diagnostic mode**

However, these are **not independent signal generators**.

---

# 3. Fundamental Design Philosophy

The biggest architectural decision made during the discussion is:

> **Confluence should rank a valid setup, not create a setup.**

For example:

### Wrong approach

```text
IFVG = +2
OB = +2
VWAP = +1
RSI = +1
SMT = +2
Discount = +2

Total > threshold
→ BUY
```

This can produce a trade from a collection of weak/unrelated conditions.

### Desired approach

```text
Liquidity
    ↓
Sweep
    ↓
Displacement
    ↓
MSS/CHoCH
    ↓
POI
    ↓
Retest
    ↓
Eligibility Gate
    ↓
Confluence / Quality Score
    ↓
Signal Grade
```

Therefore:

**Core structure determines whether a trade is possible.**

**Confluence determines how good that trade is.**

---

# 4. Core Reversal Model

The primary V1 signal model is:

## Bullish

```text
Sell-side liquidity identified
        ↓
Sell-side liquidity swept
        ↓
Bullish displacement
        ↓
Bullish internal MSS/CHoCH
        ↓
Bullish structural FVG/IFVG
        ↓
POI retest
        ↓
Confirmed bullish reaction
        ↓
LONG
```

## Bearish

Exact inverse:

```text
Buy-side liquidity identified
        ↓
Buy-side liquidity swept
        ↓
Bearish displacement
        ↓
Bearish internal MSS/CHoCH
        ↓
Bearish structural FVG/IFVG
        ↓
POI retest
        ↓
Confirmed bearish reaction
        ↓
SHORT
```

This is the **primary institutional-style reversal model**.

---

# 5. Continuation Model

A separate continuation model will eventually be implemented.

Example:

```text
Established HTF trend
        ↓
MTF pullback
        ↓
Relevant OB / Breaker / FVG / IFVG
        ↓
Premium/Discount alignment
        ↓
Internal confirmation
        ↓
Continuation entry
```

Liquidity sweep is **not mandatory** for continuation.

Reversal and continuation should have separate internal classifications.

If both qualify simultaneously:

> **Reversal takes priority over continuation.**

---

# 6. Signal State Machine

The indicator should not maintain dozens of unrelated Boolean flags.

The core reversal engine should operate as a state machine.

Proposed states:

```text
IDLE
WAIT_DISPLACEMENT
WAIT_MSS
WAIT_POI
WAIT_RETEST
READY
TRIGGERED
INVALIDATED
EXPIRED
```

### Long example

```text
IDLE
 ↓
SELL-SIDE LIQUIDITY SWEPT
 ↓
WAIT_DISPLACEMENT
 ↓
BULLISH DISPLACEMENT
 ↓
WAIT_MSS
 ↓
BULLISH MSS
 ↓
WAIT_POI
 ↓
STRUCTURAL IFVG / FVG / OB FOUND
 ↓
WAIT_RETEST
 ↓
PRICE ENTERS POI
 ↓
READY
 ↓
CONFIRMED REACTION
 ↓
TRIGGERED
```

This prevents stale events from combining into false signals.

---

# 7. Timing Windows

The system should not allow a liquidity sweep from many bars ago to remain relevant indefinitely.

Initial engineering defaults:

| Parameter                      |  Default |
| ------------------------------ | -------: |
| Internal pivot                 |   2 bars |
| External pivot                 |   5 bars |
| Liquidity sweep → displacement |   5 bars |
| Sweep setup lifetime           |  20 bars |
| MSS confirmation window        |  ~3 bars |
| POI lifetime                   | ~30 bars |

These are **initial engineering parameters**, not optimized trading parameters.

They must be configurable.

---

# 8. Non-Repainting Requirements

This is a hard requirement.

The indicator must not:

* create historical signals using future information
* move a signal after it has been generated
* delete a previously confirmed signal
* use an unconfirmed pivot as though it were known
* allow intrabar conditions to become permanent signals before candle close
* use unconfirmed HTF data

The primary signal trigger must use:

```text
barstate.isconfirmed
```

or equivalent confirmed-bar logic.

---

# 9. Pivot Confirmation

A pivot should only become known after the required confirmation bars.

For example, with a pivot strength of 5:

```text
Actual pivot:
bar 100

Confirmation:
bar 105
```

The chart may visually place the pivot marker at bar 100.

But internally:

```text
pivotConfirmationBar = 105
```

The engine must not use that pivot to generate a signal before bar 105.

This distinction is critical for avoiding lookahead/repainting.

---

# 10. Market Structure Engine

The structure engine will contain at least two layers:

### Internal structure

Used for:

* MSS
* CHoCH
* short-term structural shifts
* execution confirmation

### External structure

Used for:

* major trend
* protected highs/lows
* major BOS
* HTF/MTF bias

The system should classify:

```text
HH
HL
LH
LL
```

and structural events:

```text
BOS
CHoCH
MSS
```

with internal/external distinction.

Diagnostic labels should distinguish:

```text
iBOS
xBOS
iMSS
xMSS
```

or equivalent terminology.

---

# 11. Protected Highs and Lows

The engine should track protected structural points.

For example:

```text
Protected High
Protected Low
```

This is important for determining whether a structural break is meaningful.

A wick through a level should not automatically constitute BOS/MSS.

Default structural confirmation:

> **Candle close through the relevant structural level.**

---

# 12. Liquidity Engine

Liquidity should be treated as a persistent object with a lifecycle.

Potential liquidity sources:

### External liquidity

* major confirmed swing highs
* major confirmed swing lows

### Internal liquidity

* internal swing highs/lows

### Equal highs/lows

* EQH
* EQL

### Reference liquidity

* PDH
* PDL
* PWH
* PWL
* PMH
* PML

Later:

* Asia high/low
* London high/low
* New York high/low

---

# 13. Liquidity Clustering

Multiple liquidity sources at approximately the same price should become one cluster.

Example:

```text
PDH
External High
Equal High
```

Instead of treating these as three independent liquidity pools:

```text
BSL CLUSTER

Sources:
PDH
EXT HIGH
EQH
```

This prevents double-counting.

Initial tolerance:

```text
ATR × 0.10
```

This should be configurable.

---

# 14. Liquidity Lifecycle

A liquidity pool should have states such as:

```text
ACTIVE
SWEPT
INVALIDATED
ARCHIVED
```

The important design decision is:

> **Liquidity does not simply disappear when taken.**

Once swept, it becomes historical information.

For example:

```text
PDL
ACTIVE
```

becomes:

```text
PDL
SWEPT
```

The sweep becomes a **LiquidityEvent** that can initiate a reversal setup.

---

# 15. Sweep Detection

For sell-side liquidity:

```text
low < liquidityLevel
AND
close > liquidityLevel
```

For buy-side:

```text
high > liquidityLevel
AND
close < liquidityLevel
```

The event is only committed on confirmed candle close.

A wick alone is therefore not automatically a valid liquidity sweep.

---

# 16. Sweep Quality

Liquidity sweeps should eventually receive quality information.

Potential factors:

* major vs minor liquidity
* penetration depth
* reclaim
* displacement afterward
* structural consequence
* multiple liquidity pools taken

However, not all of these are available at the instant of the sweep.

Therefore the quality can evolve as the setup progresses.

Example:

```text
Sweep initially:
2/5

After displacement:
3/5

After MSS:
4/5
```

---

# 17. Displacement Engine

Displacement is not merely a large candle.

Initial concept:

```text
range >= ATR × multiplier
```

plus:

```text
body / range >= minimumBodyRatio
```

plus:

```text
strong close location
```

Initial suggested values:

```text
ATR multiplier = 1.0
Body ratio = 0.60
Close location = 0.70
```

All configurable.

The exact thresholds will require testing.

---

# 18. FVG Engine

Bullish FVG:

```text
low > high[2]
```

Bearish FVG:

```text
high < low[2]
```

Minimum size should eventually be filtered relative to ATR.

An FVG associated with:

```text
liquidity sweep
+
displacement
+
MSS
```

is considered much more important than an isolated FVG.

This is a **structural FVG**.

---

# 19. IFVG Engine

An FVG can transition into an IFVG when it is violated and accepted from the opposite direction.

Conceptually:

```text
Bearish FVG
      ↓
Price closes above it
      ↓
Bullish IFVG
```

and vice versa.

The FVG should be treated as a persistent object whose state can change, rather than creating unnecessary duplicate objects.

---

# 20. POI Clustering

When multiple related structures overlap:

```text
IFVG
+
OB
+
Breaker
```

they should form a single:

> **POI Cluster**

rather than three independent entry signals.

Priority concept:

```text
Structural IFVG
IFVG + OB
Structural OB
Breaker
Ordinary FVG
```

This prevents signal duplication.

---

# 21. Order Block Logic

An OB should **not** be every last opposing candle before a move.

It should be associated with meaningful displacement and preferably a structural consequence.

Basic bullish chain:

```text
Bearish candle/base
        ↓
Bullish displacement
        ↓
BOS/MSS
        ↓
Bullish OB
```

OB search depth initially:

```text
3 candles
```

The algorithm should consider:

* proximity to displacement
* body quality
* consolidation/base characteristics
* structural consequence

---

# 22. OB Invalidation

A bullish OB is invalidated by a confirmed close below its low.

A bearish OB is invalidated by a confirmed close above its high.

A wick through the OB does not automatically invalidate it.

Mitigation should eventually distinguish:

```text
Untouched
Partial
Deep
Fully consumed
```

---

# 23. Breaker Blocks

A breaker is not simply an OB that gets wicked through.

Required:

```text
OB
 ↓
failure/invalidation
 ↓
structural acceptance
 ↓
Breaker
```

Therefore a failed OB can transition into a breaker.

Breakers are especially relevant to continuation models.

---

# 24. Premium / Discount

The dealing range is based on confirmed structural extremes.

Conceptually:

```text
Confirmed swing high
        ↓
       100%
        │
     Premium
        │
       50%
   Equilibrium
        │
     Discount
        │
        0%
        ↓
Confirmed swing low
```

Initial zones:

```text
0–45%    Discount
45–55%   Equilibrium
55–100%  Premium
```

These are configurable.

Premium/discount is **context**, not a mandatory signal condition.

---

# 25. HTF/MTF Bias

The indicator will eventually use:

```text
HTF
 ↓
MTF
 ↓
Execution TF
```

Bias states:

```text
BULLISH
BEARISH
NEUTRAL
TRANSITION
UNKNOWN
```

The HTF bias should describe the structural environment rather than predict direction.

---

# 26. Bias Strength

Suggested:

```text
0 = Neutral
1 = Weak
2 = Moderate
3 = Strong
```

Example:

```text
Daily: Bullish 3
1H:    Bearish 1
```

Interpretation:

> Strong bullish HTF environment with a shallow bearish MTF correction.

---

# 27. Bias Matrix

| HTF                           | MTF             | Interpretation                |
| ----------------------------- | --------------- | ----------------------------- |
| Bullish                       | Bullish         | Strong continuation           |
| Bullish                       | Bearish         | Potential corrective reversal |
| Bearish                       | Bearish         | Strong continuation           |
| Bearish                       | Bullish         | Potential corrective reversal |
| Neutral                       | Bullish/Bearish | Lower confidence              |
| HTF directional + MTF neutral | Wait            |                               |

Countertrend signals are allowed, but should require substantially stronger evidence.

---

# 28. Divergence Strategy

We explicitly decided to **limit divergence types** to avoid excessive calculations, object usage, clutter, and false signals.

Only two families should be implemented:

### 1. SMT

For instruments with a meaningful relationship.

Examples:

* ES/NQ
* BTC/ETH
* EURUSD/GBPUSD

The comparison symbol must be user-selected.

### 2. RSI price/momentum divergence

For markets where SMT is not useful.

Example:

```text
Price:
Lower Low

RSI:
Higher Low
```

or:

```text
Price:
Higher High

RSI:
Lower High
```

RSI default:

```text
14
```

Divergence is a **confirmation/enhancer**, not a primary signal generator.

---

# 29. Divergence Limits

We intentionally rejected having many momentum indicators.

No need for:

* RSI
* MACD
* Stochastic
* CCI
* ROC
* etc.

all simultaneously.

The objective is:

> **1–2 high-value divergence mechanisms rather than indicator overload.**

SMT is preferred where intermarket relationships make sense.

RSI divergence covers instruments where SMT isn't applicable.

---

# 30. VWAP

Eventually support:

* Session VWAP
* Daily VWAP
* Weekly VWAP
* Monthly VWAP

VWAP is **context**, not a standalone signal.

Example:

```text
Bullish setup
+
VWAP reclaim
```

can increase quality.

But:

```text
VWAP cross
→ BUY
```

is explicitly rejected.

---

# 31. VWAP Lifecycle

Session VWAP:

```text
Session begins
 ↓
VWAP calculated
 ↓
Session ends
 ↓
VWAP freezes
```

Previous session VWAP should not continue calculating into the next session.

User options should eventually control:

```text
Current only
Previous 1
Previous 3
All
```

to reduce clutter.

Daily/weekly/monthly VWAPs have their own reset cycles.

---

# 32. Sessions

Sessions eventually include:

* Asia
* London
* New York

Session times should be configurable and preferably use a user-selected timezone or exchange timezone.

Each session stores:

```text
Open
High
Low
Close
Start
End
Range
VWAP
Status
```

Session highs/lows become liquidity objects after the session closes.

---

# 33. Session Display

Three eventual display modes:

### Clean

Only current/important session information.

### Standard

Current session plus important completed session highs/lows.

### Analysis

Full session ranges and history.

Session calculations must continue regardless of whether their drawings are hidden.

---

# 34. Signal Grading

The system should use:

```text
Eligibility Gate
        ↓
Quality Score
        ↓
Grade
```

rather than a simple confluence counter.

Potential grades:

```text
C
B
A
A+
A++
```

Initial proposed score thresholds:

```text
0–5     C
6–8     B
9–11    A
12–14   A+
15+     A++
```

These are **engineering starting points only** and must eventually be validated statistically.

---

# 35. A++ Should Be Rare

A++ should require specific structural prerequisites, not simply many points.

Conceptually:

```text
Core reversal model
+
High-quality liquidity
+
Strong displacement
+
MSS
+
Structural IFVG
+
HTF/MTF alignment
+
excellent premium/discount location
```

Then additional confluence can elevate the setup.

---

# 36. Proposed Scoring Categories

### HTF/MTF

```text
HTF aligned +3
MTF aligned +2
HTF opposing -3
```

### Liquidity

```text
Major external +3
Session +2
EQH/EQL +2
Minor +1
Multiple pools +2
```

Category should be capped.

### Structure

```text
Strong MSS +3
Normal MSS +2
Weak MSS +1
```

### POI

```text
Structural IFVG +3
IFVG + OB +4
Breaker +2
Ordinary FVG +1
```

### Location

```text
Ideal premium/discount +2
Equilibrium 0
Poor location -1
```

### VWAP

```text
Correct reclaim/rejection +1
Neutral 0
Contradictory -1
```

### Divergence

```text
Strong SMT +2
Normal SMT +1
Strong RSI +2
Normal RSI +1
```

Divergence contribution is capped.

---

# 37. Entry Logic

Two eventual modes:

### Aggressive

Price enters POI.

### Confirmed

Price enters POI and produces a rejection/internal confirmation.

Default recommendation:

> **Confirmed entry mode.**

This prioritizes clean, non-repainting signals over maximum entry precision.

---

# 38. Stop Loss

For a bullish reversal:

```text
SL = sweep low - ATR buffer
```

For bearish:

```text
SL = sweep high + ATR buffer
```

The exact buffer will be configurable.

---

# 39. Targets

Targets should preferentially be based on actual liquidity.

For a long:

```text
TP1 = nearest opposing internal liquidity
TP2 = session/reference liquidity
TP3 = major external liquidity
```

For a short, inverse.

RR-based targets may eventually be provided as an option, but the institutional model should prioritize **liquidity targets**.

---

# 40. Signal Locking

Once a signal is confirmed:

```text
Signal ID
Direction
Type
Grade
Entry
SL
TPs
Time
Liquidity source
Sweep
MSS
POI
Score
Status
```

becomes effectively immutable.

A historical A+ signal must not later become B or disappear because later price action changed the context.

This is essential for honest backtesting and visual evaluation.

---

# 41. Duplicate Signal Prevention

A POI should not produce:

```text
BUY
BUY
BUY
```

every time it is touched.

Once consumed:

```text
signalConsumed = true
```

Another signal requires a genuinely new structural/liquidity event.

---

# 42. Clean Chart Philosophy

The chart should not become a wall of:

* FVG boxes
* OB boxes
* BOS labels
* liquidity lines
* VWAPs
* sessions
* divergence markers
* signals

The calculation engine and visualization engine must therefore be separate.

Conceptually:

```text
calculated = TRUE
drawn = FALSE
```

is perfectly valid.

Hiding drawings must **never disable the underlying engine**.

---

# 43. Display Modes

### Clean

Shows primarily:

* signals
* active POI
* entry
* SL
* targets

### Analysis

Shows:

* structure
* liquidity
* FVG/IFVG
* OB/Breaker
* sessions
* VWAP
* signals

### Diagnostic

Shows the internal engine state.

---

# 44. Diagnostic Mode

This was the latest feature we explicitly decided to add.

Diagnostic mode is a **first-class engineering layer**.

It does not modify the calculations.

It exposes what the engine believes is happening.

---

# 45. Diagnostic Panel

Example:

```text
┌─────────────────────────────┐
│ INSTITUTIONAL ENGINE        │
├─────────────────────────────┤
│ Internal Structure: BULLISH │
│ External Structure: BULLISH │
│                             │
│ Last BOS:       12 bars ago │
│ Last MSS:        4 bars ago │
│                             │
│ Buy-side Liq:   ACTIVE      │
│ Sell-side Liq:  SWEPT       │
│                             │
│ Active Sweep:   SSL         │
│ Sweep Quality:  3 / 5       │
│                             │
│ Setup State:    WAIT_MSS     │
│ Setup Age:      2 bars      │
│ Expiry:         18 bars     │
└─────────────────────────────┘
```

---

# 46. Diagnostic Event Log

Example:

```text
EVENT LOG
────────────────────
14:35 SSL identified
14:40 SSL swept
14:40 Setup #12 created
14:45 Displacement confirmed
14:50 MSS confirmed
```

A rolling 5–10 events is sufficient.

---

# 47. Diagnostic Rejection Reasons

This is particularly important.

If there is no signal:

```text
SETUP REJECTED

✓ Liquidity sweep
✓ Displacement
✗ MSS
— POI
— Retest

Reason:
NO QUALIFYING MSS
```

Or:

```text
SETUP REJECTED

✓ Liquidity sweep
✓ Displacement
✓ MSS
✓ IFVG
✗ Retest

Reason:
POI NOT RETESTED
```

Suggested internal reason codes:

```text
NO_LIQUIDITY
SWEEP_NOT_CONFIRMED
SWEEP_EXPIRED
NO_DISPLACEMENT
DISPLACEMENT_EXPIRED
NO_MSS
MSS_INVALIDATED
NO_POI
POI_EXPIRED
RETEST_FAILED
HTF_CONFLICT
SIGNAL_ALREADY_CONSUMED
```

---

# 48. Diagnostic Pivot Audit

The diagnostic mode should show the difference between:

```text
Pivot occurred
```

and:

```text
Pivot became confirmed
```

For example:

```text
Pivot bar:       500
Confirmation:    505
```

This is specifically designed to help detect accidental lookahead.

---

# 49. Diagnostic Liquidity Audit

A liquidity level should expose its source:

```text
BSL CLUSTER

Sources:
PDH
External High
EQH

State:
ACTIVE
```

After the sweep:

```text
BSL CLUSTER

Sources:
PDH
External High
EQH

State:
SWEPT

Sweep quality:
4/5
```

---

# 50. Diagnostic Setup Audit

Example:

```text
ACTIVE SETUP
──────────────────
Direction: LONG
Origin: SSL sweep
Age: 4 bars
State: WAIT_MSS
Expires: 16 bars
```

This will allow us to understand why the state machine is or isn't progressing.

---

# 51. Diagnostic Mode Settings

Potential controls:

```text
Display Mode
    Clean
    Analysis
    Diagnostic

Show Structure Diagnostics
Show Liquidity Diagnostics
Show Sweep Diagnostics
Show State Machine
Show Event Log
Show Rejection Reasons
Show Pivot Confirmation
Show Object IDs
Show Developing Conditions
```

And diagnostic history:

```text
5 / 10 / 20 events
```

---

# 52. Diagnostic Mode Must Never Alter Logic

Absolutely critical.

The engine should calculate normally:

```text
ENGINE
  ↓
STATE
  ├──→ SIGNAL OUTPUT
  └──→ DIAGNOSTIC OUTPUT
```

Not:

```text
if diagnosticMode
    calculate differently
```

The diagnostic system is simply a read-only window into the engine.

---

# 53. Pine Architecture

The indicator should eventually use modular user-defined types/structures conceptually equivalent to:

```text
Swing
LiquidityPool
LiquidityEvent
FVG
OrderBlock
Breaker
POICluster
SessionState
Signal
```

The first prototype needs:

```text
Swing
LiquidityPool
LiquidityEvent
Signal/setup state
```

---

# 54. Calculation vs Visualization

This architectural rule should remain throughout development:

```text
CALCULATION ENGINE
        ↓
STATE
        ↓
VISUALIZATION
```

Never:

```text
drawing exists
→ therefore condition exists
```

Drawing visibility must have zero influence on trading logic.

---

# 55. Object Limits

We should impose conservative internal limits rather than approaching TradingView's maximums.

Initial target:

```text
Active liquidity: ≤ 50
Active FVGs:      ≤ 30
Active OBs:       ≤ 20
Active signals:   ≤ 50
```

Diagnostic drawings should also have a controlled cap.

Old objects can be logically archived and their drawings deleted/recycled.

---

# 56. First Development Phase

We explicitly decided **not** to immediately write the full indicator.

The development sequence is:

## Prototype 01

**Market Structure + Liquidity + Diagnostic Framework**

Build and test:

* pivots
* internal structure
* external structure
* HH/HL/LH/LL
* protected highs/lows
* BOS
* CHoCH/MSS
* liquidity pools
* liquidity clusters
* PDH/PDL
* PWH/PWL
* PMH/PML
* EQH/EQL
* sweep detection
* sweep state
* setup expiry
* diagnostic output
* non-repainting audit

---

## Prototype 02

Add:

* displacement
* FVG
* IFVG
* integration with state machine

---

## Prototype 03

Build the first real signal:

```text
Liquidity Sweep
→ Displacement
→ MSS
→ Structural IFVG
→ Retest
→ Confirmed Signal
```

---

## Prototype 04

Add:

* Order Blocks
* Breakers
* POI clustering

---

## Prototype 05

Add:

* sessions
* previous D/W/M levels
* session highs/lows
* session VWAP
* daily VWAP
* weekly VWAP
* monthly VWAP

---

## Prototype 06

Add:

* HTF bias
* MTF bias
* SMT
* RSI divergence

---

## Prototype 07

Add:

* scoring
* A/B/C grades
* A+
* A++
* alerts
* clean-chart optimization
* final object lifecycle management

---

# 57. Prototype 01 Acceptance Tests

Before proceeding to FVG/IFVG, Prototype 01 should pass:

### Test 1 — Repainting

Reload chart.

**Expected:** historical events/signals remain identical.

### Test 2 — Intrabar

Allow a potential structure/liquidity event to develop.

**Expected:** no confirmed event until candle close.

### Test 3 — Pivot delay

A pivot cannot influence the engine before confirmation.

### Test 4 — Stale sweep

Sweep occurs but no displacement within the allowed window.

**Expected:** setup expires.

### Test 5 — Wick-only structural break

Wick crosses structure but candle closes back.

**Expected:** no BOS.

### Test 6 — True structural break

Candle closes through structure.

**Expected:** BOS/MSS.

### Test 7 — Liquidity clustering

PDH and external high are near each other.

**Expected:** one liquidity cluster, not two independent pools.

### Test 8 — Sweep lifecycle

Liquidity is taken.

**Expected:** pool becomes SWEPT, not simply deleted.

### Test 9 — Hidden drawings

Hide liquidity/structure drawings.

**Expected:** calculations remain identical.

### Test 10 — Duplicate events

Same liquidity area gets revisited.

**Expected:** no duplicate setup unless a new qualifying event occurs.

---

# 58. The Most Important Development Principle

Do **not optimize the trading strategy while simultaneously debugging the code**.

First establish:

> **Does the engine correctly identify the events we intended it to identify?**

Only then ask:

> **Are those events profitable?**

This separation is important.

Otherwise a coding error can be mistaken for a strategy weakness.

---

# 59. What We Should Build First

The first actual engine should therefore be:

```text
                    PRICE
                      │
                      ▼
             CONFIRMED PIVOTS
                      │
             ┌────────┴────────┐
             ▼                 ▼
       INTERNAL STRUCTURE   EXTERNAL STRUCTURE
             │                 │
             └────────┬────────┘
                      ▼
               LIQUIDITY POOLS
                      │
                      ▼
              LIQUIDITY CLUSTERS
                      │
                      ▼
                 SWEEP ENGINE
                      │
                      ▼
                SETUP STATE
                      │
              ┌───────┴───────┐
              ▼               ▼
          NORMAL UI       DIAGNOSTIC UI
```

This is the foundation on which everything else will be built.

---

# Copy/Paste Prompt for the New Chat

Use the following prompt as the starting instruction in a new conversation:

```text
I am continuing development of a TradingView Pine Script v6 indicator that we have already architected in detail.

I want you to treat the following as the established project specification and DO NOT restart the brainstorming phase or introduce a completely different architecture.

PROJECT:
Build a non-repainting institutional/SMC-style TradingView indicator inspired by concepts associated with LuxAlgo and the IFVG model/PJ Trades.

The ultimate indicator will contain:

- FVG
- IFVG
- Order Blocks
- Breaker Blocks
- Market Structure: HH, HL, LH, LL, BOS, CHoCH, MSS
- Liquidity
- Previous Day High/Low
- Previous Week High/Low
- Previous Month High/Low
- Asia/London/New York session highs/lows
- Premium/Discount
- HTF bias
- MTF bias
- SMT divergence
- RSI/momentum divergence
- Session/Daily/Weekly/Monthly VWAP
- Signal scoring and grades
- Alerts
- Clean chart modes
- Diagnostic/debug mode

CORE PHILOSOPHY:

The indicator must NOT simply add unrelated confluence points together.

The model should be causal:

Liquidity → Sweep → Displacement → MSS/CHoCH → POI → Retest → Eligibility Gate → Quality Score → Signal.

Confluence should rank an already-valid setup rather than create a trade.

PRIMARY V1 REVERSAL MODEL:

LONG:

Sell-side liquidity identified
→ confirmed liquidity sweep
→ bullish displacement
→ bullish internal MSS/CHoCH
→ structural bullish FVG/IFVG
→ POI retest
→ confirmed bullish reaction
→ LONG signal.

SHORT is the exact inverse.

A liquidity sweep by itself is NOT a signal.
An FVG by itself is NOT a signal.
An OB by itself is NOT a signal.
A VWAP cross is NOT a signal.
Divergence is NOT a signal.

CORE STATE MACHINE:

IDLE
WAIT_DISPLACEMENT
WAIT_MSS
WAIT_POI
WAIT_RETEST
READY
TRIGGERED
INVALIDATED
EXPIRED

The state machine exists to prevent stale events from combining into false setups.

INITIAL ENGINEERING PARAMETERS:

Internal pivot strength: 2 bars
External pivot strength: 5 bars
Equal-high/low tolerance: 0.10 ATR
Sweep confirmation: candle close
Sweep/setup lifetime: 20 bars
Displacement window: approximately 5 bars
MSS confirmation window: approximately 3 bars
POI lifetime: approximately 30 bars

These are initial engineering defaults only and must be configurable.

NON-REPAINTING REQUIREMENTS:

- Use confirmed candle closes for final events/signals.
- Do not use developing pivots as confirmed information.
- If a pivot visually occurs at bar 100 but is confirmed at bar 105, the engine must not use it before bar 105.
- Historical signals must not change after chart reload.
- A confirmed signal must not disappear later.
- Do not use future information.
- HTF calculations must also use confirmed/non-lookahead logic.
- Visualization may place a confirmed pivot marker back at its actual pivot bar, but internal logic must respect the confirmation bar.

PROTOTYPE 01 — BUILD THIS FIRST:

Do NOT build the entire indicator yet.

Build only:

1. Confirmed internal pivots
2. Confirmed external pivots
3. HH/HL/LH/LL classification
4. Protected highs/lows
5. Internal BOS
6. External BOS
7. Internal MSS/CHoCH
8. External MSS/CHoCH
9. Liquidity pools
10. Liquidity clustering
11. Equal highs/lows
12. PDH/PDL
13. PWH/PWL
14. PMH/PML
15. Liquidity sweep detection
16. Liquidity lifecycle
17. Sweep/setup state
18. Setup expiry
19. Diagnostic mode
20. Non-repainting audit

Do NOT add FVG/IFVG, OB, Breaker, VWAP, sessions, SMT, RSI divergence, or final scoring yet.

LIQUIDITY ENGINE:

Liquidity sources:

- External confirmed swing highs/lows
- Internal confirmed swing highs/lows
- Equal highs/lows
- PDH/PDL
- PWH/PWL
- PMH/PML

Liquidity objects should have states such as:

ACTIVE
SWEPT
INVALIDATED
ARCHIVED

Do NOT simply delete liquidity when it is swept.

When a level is swept, create a LiquidityEvent and allow it to initiate the reversal state machine.

Sweep logic:

Sell-side:
low < liquidityLevel AND close > liquidityLevel

Buy-side:
high > liquidityLevel AND close < liquidityLevel

Only commit the event on candle confirmation.

LIQUIDITY CLUSTERING:

If multiple liquidity sources are close together, combine them into one cluster.

Example:

PDH + External High + EQH

should become one BSL cluster with multiple sources, rather than three independent liquidity pools.

Initial tolerance:
ATR × 0.10

Make configurable.

STRUCTURE:

Maintain separate internal and external structure.

Classify:

HH
HL
LH
LL

Track:

- protected highs
- protected lows
- broken levels
- structure direction
- last BOS
- last MSS/CHoCH

A wick through structure should not automatically produce BOS/MSS.

Default structural confirmation is a candle close through the relevant level.

DISPLACEMENT:

Eventually use something conceptually like:

range >= ATR × multiplier
body/range >= minimum body ratio
strong close location

Initial defaults:

ATR multiplier = 1.0
Body ratio = 0.60
Close location = 0.70

But displacement is NOT part of Prototype 01 yet. Leave a clean interface so Prototype 02 can plug it into the state machine.

DIAGNOSTIC MODE:

Diagnostic mode is a first-class engineering feature.

It MUST NOT alter calculation or signal logic.

Architecture:

ENGINE
↓
STATE
├── Signal Output
└── Diagnostic Output

Diagnostic mode should expose exactly what the engine believes is happening.

Provide three display modes:

1. CLEAN
2. ANALYSIS
3. DIAGNOSTIC

Diagnostic panel should eventually expose:

- Internal structure
- External structure
- Last BOS
- Last MSS
- Buy-side liquidity state
- Sell-side liquidity state
- Active liquidity event
- Liquidity source
- Sweep quality
- Active setup direction
- State-machine state
- Setup age
- Setup expiry
- Last event
- Rejection reason

Example:

INSTITUTIONAL ENGINE
Internal Structure: BULLISH
External Structure: BULLISH
Last BOS: 12 bars ago
Last MSS: 4 bars ago
Buy-side Liquidity: ACTIVE
Sell-side Liquidity: SWEPT
Active Sweep: SSL
Sweep Quality: 3/5
Setup State: WAIT_MSS
Setup Age: 2 bars
Expiry: 18 bars

DIAGNOSTIC EVENT LOG:

Keep a rolling 5–10 event history, e.g.:

SSL identified
SSL swept
Setup #12 created
Displacement confirmed
MSS confirmed

DIAGNOSTIC REJECTION REASONS:

Use explicit internal reason codes such as:

NO_LIQUIDITY
SWEEP_NOT_CONFIRMED
SWEEP_EXPIRED
NO_DISPLACEMENT
DISPLACEMENT_EXPIRED
NO_MSS
MSS_INVALIDATED
NO_POI
POI_EXPIRED
RETEST_FAILED
HTF_CONFLICT
SIGNAL_ALREADY_CONSUMED

For Prototype 01, use the relevant structure/liquidity rejection reasons.

PIVOT AUDIT:

Diagnostic mode should expose:

Pivot bar
Confirmation bar
Pivot type
Pivot strength

Example:

Pivot bar: 500
Confirmation bar: 505

This is specifically to audit against lookahead/repainting.

OBJECT IDS:

Use IDs where useful:

Swing #x
Liquidity #x
Cluster #x
Setup #x
Event #x

Keep this optional in diagnostic mode.

CALCULATION VS VISUALIZATION:

This is critical.

A calculation must remain active even if its drawings are hidden.

For example:

calculated = TRUE
drawn = FALSE

must be valid.

Never make signal logic dependent on whether an object is visible.

OBJECT LIMITS:

Use conservative internal limits.

Initial targets:

Active liquidity ≤ 50
Active FVGs ≤ 30
Active OBs ≤ 20
Active signals ≤ 50

Diagnostic drawings must also be capped/recycled.

USER EXPERIENCE:

Clean mode should eventually show only important information:
- signals
- active POI
- entry
- SL
- targets

Analysis mode can show:
- structure
- liquidity
- FVG/IFVG
- OB/Breaker
- sessions
- VWAP
- signals

Diagnostic mode exposes the engine internals.

DEVELOPMENT ROADMAP:

Prototype 01:
Market Structure + Liquidity + Diagnostic Framework

Prototype 02:
Displacement + FVG + IFVG + state-machine integration

Prototype 03:
First actual non-repainting signal:
Liquidity Sweep → Displacement → MSS → Structural IFVG → Retest

Prototype 04:
Order Blocks + Breakers + POI clustering

Prototype 05:
Sessions + Previous D/W/M levels + Session/Daily/Weekly/Monthly VWAP

Prototype 06:
HTF/MTF bias + SMT + RSI divergence

Prototype 07:
Scoring + A/B/C grades + A+ + A++ + alerts + clean-chart optimization

DIVERGENCE:

Keep divergence deliberately limited to:

1. SMT
2. RSI price/momentum divergence

Do not add many oscillators.

Divergence is confirmation only.

SIGNAL SCORING:

Do not implement scoring in Prototype 01.

Eventually use:

Eligibility Gate
→ Quality Score
→ Grade

rather than simply adding arbitrary indicator points.

Potential eventual grades:

C
B
A
A+
A++

A++ must remain rare and require strong structural prerequisites.

ORDER BLOCKS:

Eventually require causal association with displacement/structure.

Do not identify every last opposing candle as an OB.

BREAKERS:

An OB becomes a breaker only after meaningful invalidation plus structural acceptance.

PREMIUM/DISCOUNT:

Eventually use confirmed structural dealing ranges.

Approximate initial zones:

0–45% Discount
45–55% Equilibrium
55–100% Premium

Context only, not a mandatory signal condition.

VWAP:

Eventually support:

Session
Daily
Weekly
Monthly

VWAP is context/enhancement, not a standalone signal.

SESSIONS:

Eventually support:

Asia
London
New York

Session high/low becomes liquidity after session completion.

Session calculations must continue even if drawings are hidden.

SIGNAL LOCKING:

Once a confirmed signal exists, its:

ID
direction
type
grade
entry
SL
TPs
time
liquidity source
sweep
MSS
POI
score
status

must be effectively immutable.

DUPLICATE SIGNAL PREVENTION:

The same POI should not produce repeated signals simply because price touches it multiple times.

A consumed POI requires a new qualifying structural/liquidity event before generating another signal.

PROTOTYPE 01 ACCEPTANCE TESTS:

1. Chart reload produces identical historical events.
2. Intrabar conditions do not become confirmed events.
3. Pivots cannot influence logic before confirmation.
4. Stale liquidity sweeps expire.
5. Wick-only structural breaks do not create BOS.
6. Confirmed closes through structure create BOS/MSS appropriately.
7. Near-identical liquidity sources cluster.
8. Swept liquidity changes state rather than disappearing.
9. Hiding drawings does not alter calculations.
10. Repeated visits do not create duplicate setup events.

IMPORTANT DEVELOPMENT RULE:

Do not try to optimize the trading strategy while simultaneously debugging the engine.

First prove that the engine correctly identifies the intended market events.

Then evaluate whether those events have predictive/trading value.

YOUR NEXT TASK:

Start building Prototype 01 in Pine Script v6.

Do NOT provide a vague conceptual answer.

Create the actual Pine v6 implementation for:

- confirmed internal/external pivots
- HH/HL/LH/LL
- protected structure
- BOS/MSS/CHoCH
- liquidity pools
- liquidity clustering
- PDH/PDL
- PWH/PWL
- PMH/PML
- EQH/EQL
- liquidity sweep detection
- liquidity lifecycle
- setup state machine foundation
- setup expiry
- diagnostic mode
- diagnostic panel
- event log
- rejection/debug state
- non-repainting architecture

Keep the code modular and clearly commented.

Do not implement FVG/IFVG, OB, Breaker, VWAP, sessions, divergence, or scoring yet.

After providing Prototype 01, explain the architecture and specifically identify any Pine v6 limitations or design compromises that could affect the later engines.

The goal is to build the engines first, validate them, and then progressively assemble the complete indicator.
```

---

## Immediate starting point

The new chat should begin with **Prototype 01**, not another design discussion.

The development target is therefore:

**`Market Structure Engine → Liquidity Engine → Sweep Engine → State Machine → Diagnostic Engine`**

Once that is working and passes the acceptance tests, we move directly into:

**`Displacement Engine → FVG Engine → IFVG Engine`**

and then connect that to the first actual **non-repainting entry signal**.

This gives us a clean foundation instead of trying to debug a 2,000-line indicator whose individual engines cannot be isolated.
