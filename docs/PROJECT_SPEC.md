# ARTHA Project Specification

## Objective

Build a non-repainting TradingView Pine Script v6 institutional-style indicator inspired by SMC/institutional concepts, including FVG/IFVG, Order Blocks/Breaker Blocks, market structure, liquidity, previous D/W/M levels, sessions, premium/discount, HTF/MTF bias, limited divergence, VWAP, signal grading, alerts, clean visualization, and diagnostic mode.

## Core signal philosophy

The system is event-driven. Confluence ranks a valid setup; it does not create one.

Primary reversal sequence:

`Liquidity → Sweep → Displacement → MSS/CHoCH → POI → Retest → Eligibility → Quality → Signal`

A sweep, FVG, OB, VWAP event, or divergence alone is not a trade signal.

## Non-repainting contract

- Only confirmed candle information may create committed engine events.
- Developing pivots cannot influence logic before confirmation.
- HTF requests must use non-lookahead logic.
- Historical signals must remain stable after reload.
- Confirmed signals cannot disappear or change.
- Visual offset may place a confirmed pivot at its actual pivot bar, but internal logic must use its confirmation bar.

## State machine

`IDLE → WAIT_DISPLACEMENT → WAIT_MSS → WAIT_POI → WAIT_RETEST → READY → TRIGGERED`

Alternative terminal states: `INVALIDATED`, `EXPIRED`.

## Development roadmap

1. P01 — Market Structure + Liquidity + Diagnostic Framework
2. P02 — Displacement + FVG + IFVG
3. P03 — First non-repainting entry model
4. P04 — Order Blocks + Breakers + POI clustering
5. P05 — Sessions + previous D/W/M levels + VWAP
6. P06 — HTF/MTF bias + SMT + RSI divergence
7. P07 — Scoring + grades + alerts + clean UI

## P01 scope

P01 includes only confirmed internal/external pivots, HH/HL/LH/LL, protected structure, BOS/MSS/CHoCH, liquidity pools and clustering, PDH/PDL, PWH/PWL, PMH/PML, EQH/EQL, sweep detection/lifecycle, setup-state foundation, expiry, diagnostics, event log, rejection state, and non-repainting architecture.

P01 explicitly excludes FVG/IFVG, OB, Breaker, VWAP, sessions, divergence, and scoring.

## Architecture

`Calculation Engine → State → Visualization`

Visualization settings must never disable calculations. Diagnostic mode is read-only and must not alter engine behavior.
