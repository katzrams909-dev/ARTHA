# ARTHA v2 P17.7 — Reaction Confirmation Expansion

## Purpose

Test a wider reaction-confirmation window while reducing premature EARLY entries. P17.6 remains unchanged.

## Changes

- Reaction confirmation window now defaults to **5 bars**, configurable from 1 to 5.
- The window is counted **including the POI-touch bar**. With a five-bar window, the deadline is touch bar + 4.
- EARLY entries require at least one bar after the POI-touch bar by default. The new `EARLY · Minimum bars after POI touch` input is configurable from 1 to 3.
- MISS entries retain their existing `Allow touch-bar confirmation` behavior; the EARLY delay does not apply to MISS.
- NORMAL signal logic, setup scores, POI selection, direction arbitration, stop/target geometry, outcome math, and P17.6 result-card colors are unchanged.

## Important limitation

A wider window only gives a reaction more time to meet the existing close-confirmation rule. It does not by itself prove direction is correct or repair a reaction that is rejected by score, duplicate suppression, signal admission, or classification. Those paths need a separate diagnostic pass before changing thresholds.

## Follow-on audit required

1. **Wrong direction:** verify latest aligned structure/context, REV versus CONT family selection, opposing structure invalidation, and bull/bear arbitration.
2. **Missed entries:** instrument touch classification and rejection reasons (RAW/no context, timeout, invalidated POI, score, duplicate, re-entry suppression, conflict/admission).
3. **Stops:** compare selected stop base (causal, POI edge, protected swing) against POI/sweep/protected swing and the ATR buffer.
4. **Targets:** verify opposing liquidity side, T1/T2 ordering and separation, R constraints, and fallback target behavior.
5. Use chart examples and realized outcomes before tuning stop/target geometry; do not infer profitability from code inspection alone.

## Validation target

`pine/v2/ARTHA_V2_P17_7_Reaction_Confirmation_Expansion.pine`
