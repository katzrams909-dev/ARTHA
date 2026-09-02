# Prototype 01 Acceptance Test Plan

## Historical consistency

- Reload the chart and confirm identical historical structure/liquidity events.
- Scroll through historical data and confirm no event changes after additional bars load.

## Pivot confirmation

- Confirm internal pivots require the configured right-side bars.
- Confirm external pivots require the configured right-side bars.
- Verify a pivot cannot affect logic before its confirmation bar.

## Structure

- HH/HL/LH/LL classification is stable after confirmation.
- Wick-only crossings do not create confirmed BOS.
- Confirmed closes through relevant structure create BOS/MSS according to the engine rules.
- Internal and external structure remain distinct.

## Liquidity

- Swing highs/lows create corresponding buy-side/sell-side liquidity.
- EQH/EQL candidates within tolerance cluster instead of duplicating.
- PDH/PDL, PWH/PWL and PMH/PML are represented as reference liquidity.
- A swept pool changes lifecycle state instead of disappearing.

## Sweeps

- Buy-side sweep requires trade above level and confirmed close below.
- Sell-side sweep requires trade below level and confirmed close above.
- A sweep creates exactly one liquidity event for the affected pool.
- Repeated touches of a swept pool do not create duplicate sweep events.

## State machine

- Sweep creates the appropriate directional setup state.
- Setup expires after configured lifetime.
- Expired setup cannot produce a later signal.
- Future engines can advance state without rewriting prior events.

## Visualization

- Hiding drawings does not change engine state.
- Diagnostic mode exposes state without changing it.
- Object counts remain bounded.
