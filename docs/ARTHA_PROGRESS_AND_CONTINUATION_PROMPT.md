# ARTHA — Progress, Architecture Context & Continuation Prompt

**Date:** 2026-09-08  
**Repository:** `katzrams909-dev/ARTHA`  
**Project:** ARTHA TradingView / Pine Script institutional-style market-engine indicator

---

## 1. Project objective

ARTHA is intended to become a non-repainting TradingView indicator built around an institutional/SMC-style market model. The objective is **not** to stack unrelated indicators, but to build a coherent market-state engine that understands liquidity, structure, imbalance, location, bias and confirmation before producing a signal.

The original requested components are:

- FVG / IFVG
- Order Blocks / Breaker Blocks
- Market structure: BOS, CHoCH, MSS and related structure
- Liquidity
- Previous day/week/month high and low
- Asia / London / New York session highs and lows
- Premium / discount
- HTF / MTF bias
- Divergence
- VWAP: session, daily, weekly, monthly
- Non-repainting operation

The design was inspired by concepts seen in LuxAlgo-style tools and the IFVG model associated with PJ Trades, but ARTHA is being designed as its own state-driven engine.

---

## 2. Core design principles agreed so far

### Non-repainting is mandatory

ARTHA must not use future information to create historical signals. Confirmed bars/pivots are preferred for structural decisions. Developing data may be displayed diagnostically, but must not create confirmed historical signals.

### A liquidity sweep is NOT automatically a reversal

This is one of the most important decisions in the project.

A liquidity event should be classified separately from a structural reversal:

```text
Liquidity taken
      ↓
Sweep / reclaim?
      ↓
Displacement?
      ↓
Protected structure broken?
      ↓
MSS / CHoCH?
      ↓
Setup qualification
```

A sweep that simply continues in the same direction remains a liquidity event and should not become a reversal signal.

### Signals must be confluence-driven

An FVG, liquidity sweep, BOS, divergence or VWAP interaction by itself should generally **not** be treated as a complete entry signal. The eventual signal engine should combine context and confirmation.

### Clean chart is important

The indicator should avoid the common problem of displaying hundreds of boxes/lines/labels. Objects need lifecycle management, bounded counts and visibility controls.

### Diagnostic mode is required

An optional diagnostic mode should expose what the engine believes is happening on the chart. It is intended primarily for development/debugging and can later become an advanced user mode.

Examples of useful diagnostic state:

- current internal/external bias
- active structural level
- protected high/low
- liquidity state
- setup state
- FVG lifecycle state
- displacement value
- confirmation status

---

## 3. Renderer decisions already validated

Earlier renderer prototypes had several problems:

1. Script/code text appeared on the chart because of an incorrect display approach.
2. Level lines extended incorrectly across days/weeks/months.
3. There were no clear labels identifying levels.
4. Liquidity lines remained after liquidity was taken.
5. Labels rendered as empty/generic boxes.

These were corrected conceptually.

### Validated visual behavior

Previous D/W/M levels should be shown as **text + horizontal lines** and must correspond to the actual previous completed period.

Required labels:

- PDH / PDL
- PWH / PWL
- PMH / PML

Structure events should be **text only**, not box labels:

- iBOS ↑ / ↓
- iCHoCH ↑ / ↓
- iMSS ↑ / ↓
- xBOS ↑ / ↓
- xCHoCH ↑ / ↓
- xMSS ↑ / ↓

The P01.5 text-only renderer was visually validated by the user.

Previous D/W/M level alignment was subsequently corrected after the user reported that levels were initially one period behind. The corrected behavior was accepted as good.

---

## 4. Development progress

### P01.5 — Text-Only Renderer

**Status: VALIDATED**

Purpose: establish clean rendering for structure and liquidity references.

Key outcome:

- no generic blue boxes for structure events
- text-only event labels
- PDH/PDL/PWH/PWL/PMH/PML represented as text + lines
- cleaner chart presentation

---

### P01.6 — Structure State Engine

**Status: VALIDATED**

Purpose: build a persistent structural state model instead of using a simplistic `close > pivot = BOS` approach.

The prototype tracks:

- Internal pivots
- External pivots
- HH / HL / LH / LL classification
- Internal trend
- External trend
- Persistent structural targets
- Protected highs/lows
- Confirmed structural breaks
- BOS
- CHoCH
- MSS
- ATR-relative displacement

A significant debugging issue occurred during implementation: break references were being replaced by newly confirmed pivots, preventing stable detection. The engine was rebuilt so confirmed structural levels persist until consumed.

The user subsequently confirmed:

> works

Therefore P01.6 is considered the current validated structure foundation.

Important conceptual rule:

```text
Confirmed pivot
      ↓
Persistent structural target
      ↓
Break
      ↓
Classify using PREVIOUS trend
      ↓
BOS / CHoCH / MSS
      ↓
Consume target
      ↓
Update trend
```

---

### P01.7 — Liquidity + Structure Interaction

**Status: VALIDATED**

Purpose: connect liquidity events to structural state without treating liquidity sweeps as automatic reversals.

The prototype handles:

- Previous Day High/Low
- Previous Week High/Low
- Previous Month High/Low
- Internal/external structure
- Liquidity sweep detection
- Sweep/reclaim distinction
- Structure shift after sweep
- Setup state
- Setup direction
- Liquidity source
- Diagnostic state

Core setup states include:

- `NONE`
- `SWEEP_ONLY`
- `CONFIRMED_CHOCH`
- `CONFIRMED_MSS`
- `INVALIDATED`

Example:

```text
PDL sweep
   ↓
reclaim
   ↓
SWEEP_ONLY
   ↓
bullish CHoCH/MSS
   ↓
CONFIRMED_CHOCH / CONFIRMED_MSS
```

Counterexample:

```text
PDL sweep
   ↓
continued downside
   ↓
SWEEP_ONLY
```

The user confirmed P01.7 works OK.

---

### P02.0 — FVG / IFVG Lifecycle

**Status: CREATED — NEEDS USER VALIDATION**

Repository file:

`pine/prototypes/ARTHA_P02_0_FVG_IFVG_Lifecycle.pine`

Purpose: detect and manage FVGs as lifecycle objects rather than simply plotting every three-candle gap.

Current concepts:

- Bullish FVG
- Bearish FVG
- ATR-relative minimum gap filter
- Optional displacement requirement
- Confirmed-bar processing
- FVG mitigation
- Full-fill transition toward IFVG
- IFVG invalidation
- bounded zone count
- optional zone/text display
- diagnostic panel
- alerts

Current conceptual lifecycle:

```text
Confirmed displacement
        ↓
      FVG
        ↓
  ACTIVE / UNTOUCHED
        ↓
    MITIGATION
        ↓
      FULL FILL
        ↓
      IFVG STATE
        ↓
 polarity invalidation
```

Important: the prototype currently treats FVG → IFVG as a lifecycle state. It does **not** mean every filled FVG is automatically an entry.

P02.0 must be tested carefully before integration, especially:

1. FVG location accuracy
2. mitigation behavior
3. full-fill behavior
4. IFVG transition timing
5. invalidation behavior
6. no repainting

---

## 5. Divergence decisions

Divergence should not become an enormous collection of calculations. The agreed direction is to keep the number of divergence types deliberately small to avoid Pine limits, complexity and noise.

Use approximately **one or two high-value divergence methods per category** rather than trying to include every possible oscillator/correlation combination.

Two broad divergence families are useful:

### SMT / intermarket divergence

Useful where instruments have meaningful correlated behavior.

Example concept:

```text
Instrument A takes prior high
Instrument B fails to take corresponding high
        ↓
SMT divergence
```

### Momentum divergence

For markets/instruments where SMT is less meaningful, momentum divergence should be available.

Potential oscillators include:

- RSI
- MACD

But the final implementation should select a small number of robust methods rather than include all of them.

Divergence should ultimately be a **contextual confirmation**, not a standalone entry trigger.

---

## 6. Intended eventual signal architecture

The eventual ARTHA signal engine should be state-driven and layered.

A high-level long setup could resemble:

```text
HTF/MTF bullish context
        ↓
Price reaches meaningful liquidity / discount location
        ↓
Sell-side liquidity sweep
        ↓
Reclaim / rejection
        ↓
Bullish displacement
        ↓
MSS / CHoCH
        ↓
Relevant bullish FVG / IFVG
        ↓
Retracement into FVG/IFVG
        ↓
Additional confirmation
        ↓
LONG SIGNAL
```

Short setup is the mirror image.

The signal engine should score or qualify confluence rather than require every possible component on every trade. Otherwise the indicator will become too restrictive and generate almost no signals.

---

## 7. Components still to build

Major remaining engines:

1. **Finish and validate P02 FVG/IFVG lifecycle**
2. Order Block engine
3. Breaker Block engine
4. Session engine:
   - Asia
   - London
   - New York
   - session highs/lows
   - session boundaries
5. Previous D/W/M liquidity renderer/lifecycle integration
6. Premium/discount engine
7. HTF/MTF bias engine
8. Divergence engine:
   - limited SMT
   - limited momentum divergence
9. VWAP engine:
   - session VWAP
   - daily VWAP
   - weekly VWAP
   - monthly VWAP
   - behavior after session close
10. Unified confluence/state engine
11. Entry signal engine
12. Signal display and label system
13. Object lifecycle / hiding architecture
14. Performance and Pine object/plot-limit optimization
15. Final non-repainting audit

---

## 8. Object and display architecture requirements

The final indicator should distinguish between **engine state** and **visual rendering**.

Hiding an object should not disable the calculation that feeds the signal engine.

Conceptually:

```text
             ENGINE STATE
                  │
        ┌─────────┴─────────┐
        │                   │
   SIGNAL LOGIC        RENDERER
        │                   │
   always active       user visibility
                            │
                     hide/show objects
```

Therefore:

- `showFVG=false` must hide FVG visuals but not stop FVG calculations.
- `showLiquidity=false` must hide liquidity visuals but not stop liquidity state.
- `showStructure=false` must hide structure labels but not disable structure logic.
- Diagnostic mode must expose state without changing state.

Object lifecycles should prevent lines/boxes from extending indefinitely.

---

## 9. Plot/object limit strategy

Pine limits are an engineering constraint. ARTHA should avoid creating unlimited objects.

Preferred approach:

- arrays for tracked zones/events
- bounded queues
- delete oldest objects when limits are reached
- reuse/update objects where practical
- avoid unnecessary `plotshape()` calls
- use labels only for meaningful events
- use lines only for levels that need persistence
- keep diagnostic tables optional
- separate historical audit objects from active objects

The user explicitly requested less chart clutter and awareness of plot limits.

---

## 10. Previous D/W/M levels

These must represent the **completed previous period**, not the currently forming period.

Required:

- PDH = previous completed day high
- PDL = previous completed day low
- PWH = previous completed week high
- PWL = previous completed week low
- PMH = previous completed month high
- PML = previous completed month low

The user previously found the levels were offset by one period. This was corrected and subsequently accepted.

Future implementations must preserve that behavior.

---

## 11. Liquidity after it is taken

A liquidity level should have a lifecycle.

Example:

```text
ACTIVE
  ↓
swept
  ↓
TAKEN
  ↓
removed from active-target set
```

The historical event can remain available to diagnostics/audit, but the active liquidity line should not continue forever.

The eventual engine should also distinguish:

- untouched liquidity
- swept liquidity
- reclaimed liquidity
- invalid/consumed liquidity
- internal liquidity
- external liquidity

---

## 12. Session requirements

Sessions need explicit boundaries and must not create vertical artifacts or lines that continue indefinitely.

Required sessions:

- Asia
- London
- New York

Each session should be able to track:

- session start
- session end
- session high
- session low
- whether high/low has been taken
- session status after close

Session visuals must terminate at session boundaries.

Session calculations should continue to feed the engine even when their visual display is hidden.

---

## 13. VWAP requirements

Required VWAP scopes:

- session
- daily
- weekly
- monthly

A major unresolved design item is **VWAP behavior after a session closes**.

The engine needs to distinguish:

- currently active VWAP
- completed session VWAP
- whether historical VWAP remains displayed
- when a new VWAP begins
- whether completed VWAP remains relevant for signal context

This should be explicitly designed before final integration.

---

## 14. Signal display requirements

The final signal display should be concise and meaningful.

Avoid putting every underlying condition on the chart.

Possible hierarchy:

```text
SETUP
  ↓
CONFIRMED
  ↓
SIGNAL
```

A signal should communicate direction and setup quality without creating a wall of labels.

Diagnostic mode can expose the detailed reasons behind the signal.

---

## 15. Non-repainting policy for the whole project

Every engine must be audited for:

- future-bar references
- lookahead misuse
- developing HTF values becoming historical signals
- pivot confirmation timing
- session boundary timing
- FVG creation timing
- structure break timing
- divergence confirmation timing
- VWAP reset timing

A signal should only become a confirmed historical signal once all required information was available on that bar.

The engine may internally maintain developing state, but confirmed signal history must remain stable.

---

# 16. Current recommended architecture

The project should evolve toward the following modular architecture:

```text
ARTHA
│
├── Data / Time Engine
│   ├── timeframe state
│   ├── session boundaries
│   └── period boundaries
│
├── Structure Engine
│   ├── pivots
│   ├── HH/HL/LH/LL
│   ├── internal structure
│   ├── external structure
│   ├── protected highs/lows
│   └── BOS / CHoCH / MSS
│
├── Liquidity Engine
│   ├── swing liquidity
│   ├── PD/PW/PM liquidity
│   ├── session liquidity
│   └── sweep/reclaim lifecycle
│
├── Imbalance Engine
│   ├── FVG
│   ├── mitigation
│   ├── full fill
│   └── IFVG
│
├── Institutional Zone Engine
│   ├── Order Blocks
│   └── Breaker Blocks
│
├── Context Engine
│   ├── premium/discount
│   ├── HTF bias
│   ├── MTF bias
│   ├── VWAP
│   └── divergence
│
├── Setup Engine
│   ├── liquidity + structure
│   ├── displacement
│   ├── FVG/IFVG interaction
│   └── confluence qualification
│
├── Signal Engine
│   ├── long setup
│   ├── short setup
│   ├── confidence/quality
│   └── alert state
│
├── Renderer
│   ├── clean chart
│   ├── levels
│   ├── events
│   └── signal display
│
└── Diagnostic Engine
    ├── state visibility
    ├── event reasons
    └── debugging
```

---

# 17. Immediate next step

The immediate task is to **validate and, if necessary, refine P02.0 FVG/IFVG lifecycle**.

Do not jump directly to final signal generation.

First verify:

- FVG detection
- gap qualification
- displacement relationship
- mitigation
- full fill
- IFVG transition
- invalidation
- object lifecycle
- no repainting

Once P02 is validated, connect it to P01.7 rather than keeping the engines permanently independent.

---

# 18. Continuation prompt for a new chat

Copy/paste the following prompt into a new chat:

> **Continue the ARTHA TradingView/Pine Script indicator project from the repository `katzrams909-dev/ARTHA`.**
>
> Read `docs/ARTHA_PROGRESS_AND_CONTINUATION_PROMPT.md` first. Treat it as the current project context and progress record.
>
> ARTHA is being built as a **non-repainting, institutional-style market-state engine**, inspired by concepts commonly used in SMC/institutional trading tools and the PJ Trades IFVG model. The objective is not to stack indicators; it is to create a coherent engine that understands structure, liquidity, imbalance, location, bias and confirmation before producing signals.
>
> ## Validated foundations
>
> **P01.5 — Text-Only Renderer:** validated. Structure events are text-only. PDH/PDL/PWH/PWL/PMH/PML are text + lines. The chart should remain clean and objects should have bounded lifecycles.
>
> **P01.6 — Structure State Engine:** validated. It tracks internal/external structure, HH/HL/LH/LL, persistent structural levels, protected highs/lows, BOS, CHoCH and MSS. A previous bug caused break references to move with new pivots; the engine was rebuilt so structural targets persist until consumed. Do not regress this behavior.
>
> **P01.7 — Liquidity + Structure Interaction:** validated. It distinguishes a liquidity sweep from a reversal. A sweep does not automatically mean reversal. Setup states include concepts such as `SWEEP_ONLY`, `CONFIRMED_CHOCH`, `CONFIRMED_MSS` and `INVALIDATED`.
>
> **P02.0 — FVG/IFVG Lifecycle:** created but not yet fully validated. Start by testing/refining this engine before building additional signal logic.
>
> ## Core philosophy
>
> A liquidity sweep is NOT automatically a reversal.
>
> The desired logic is approximately:
>
> ```text
> liquidity target
>      ↓
> liquidity sweep/reclaim
>      ↓
> displacement
>      ↓
> protected structure break
>      ↓
> CHoCH / MSS
>      ↓
> FVG / IFVG interaction
>      ↓
> setup qualification
>      ↓
> signal
> ```
>
> An FVG, BOS, divergence, VWAP interaction or liquidity sweep alone should not automatically create an entry signal.
>
> ## Non-repainting requirement
>
> This is mandatory. Confirmed historical signals must never depend on future bars. Audit pivot confirmation, HTF data, sessions, FVGs, divergence, VWAP and structure carefully for lookahead/repainting behavior.
>
> ## Remaining components
>
> After P02 is validated, continue with:
>
> 1. Order Blocks / Breaker Blocks
> 2. Session engine — Asia, London, New York, including session highs/lows and clean session boundaries
> 3. Premium/discount
> 4. HTF/MTF bias
> 5. Limited divergence engine: a small SMT component plus a small momentum divergence component such as RSI/MACD for instruments where SMT is less useful
> 6. Session/daily/weekly/monthly VWAP, including explicit behavior after session close
> 7. Unified confluence/setup engine
> 8. Final entry/signal engine
> 9. Clean signal renderer
> 10. Object lifecycle and Pine plot/object-limit optimization
> 11. Final non-repainting audit
>
> ## Divergence constraint
>
> Keep divergence deliberately limited. Do not implement a huge collection of oscillators or SMT pairs. Use approximately one or two high-value methods per divergence family to avoid Pine limits, errors and excessive noise. Divergence should be confirmation/context, not automatically an entry.
>
> ## Rendering constraints
>
> Keep calculation separate from rendering. Hiding an object must never disable the underlying calculation or signal workflow. Diagnostic mode must be optional and must not change engine state.
>
> Use bounded object queues and delete/reuse old objects where appropriate. Avoid chart clutter and avoid unnecessary plotshape/label creation.
>
> ## Working method
>
> Do not rush into the final monolithic indicator. Continue building/test-validating modular prototypes in the repository. When modifying an existing file, inspect the current version first. Preserve validated behavior. Explain the logic being tested, then implement it in the repository.
>
> **Immediate instruction:** inspect and validate `pine/prototypes/ARTHA_P02_0_FVG_IFVG_Lifecycle.pine`. Fix any logical or Pine issues you find, especially FVG mitigation/full-fill/IFVG state transitions and non-repainting behavior. Then report exactly what changed and what should be tested on TradingView. Do not move to the next engine until P02 is validated.

---

## 19. Repository development rule

This document is the continuity anchor for the project. Update it when a major engine is validated, a design decision changes, or a significant bug is discovered/fixed. Keep the continuation prompt synchronized with the actual repository state.
