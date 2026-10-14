# ARTHA v2 P17.9 — Inclusive POI Fill Validation

Target: `pine/v2/ARTHA_V2_P17_9_POI_Fill_Gated_Reaction_Entries.pine`

## Compile and regression
- [ ] Pine Script v6 compiles in TradingView.
- [ ] P17.8 remains unchanged.
- [ ] Confirmation window defaults to 5 bars and remains configurable 1–5.
- [ ] EARLY minimum delay remains 1 bar after the fill-trigger bar by default.
- [ ] Normal REV/CONT entry engine, SL/TP geometry, and outcome accounting are unchanged.

## Inclusive fill thresholds
- [ ] Default threshold remains 50%.
- [ ] 15% option triggers at 15% penetration or deeper.
- [ ] 25% option triggers at 25% penetration or deeper.
- [ ] 50% option triggers at 50% penetration or deeper.
- [ ] 75% option triggers at 75% penetration or deeper.
- [ ] 100% option triggers when price reaches/passes the far POI edge.
- [ ] A deeper fill satisfies every lower threshold (e.g. 75% also satisfies 15%, 25%, and 50%).
- [ ] Thresholds are mirrored correctly for bullish and bearish POIs.
- [ ] Fill depth is calculated from wick extremes, not candle close.
- [ ] `100% + Sweep` requires price to trade strictly beyond the far POI edge.
- [ ] For `100% + Sweep`, the existing sweep-reclaim confirmation must still pass.
- [ ] Once threshold is reached, the reaction confirmation window starts on that bar.
- [ ] Invalid/retired POIs do not produce entries.

## Visual test
- [ ] Test the same chart windows in P17.8 and P17.9.
- [ ] Compare 15%, 25%, 50%, 75%, 100%, and 100% + Sweep using the same symbol/timeframe.
- [ ] Record entry depth, direction correctness, late/missed entries, and subsequent reaction quality.
- [ ] Confirm NORMAL signals are unaffected.

## Status
- Source and docs committed to `artha-v2-p17-presets`.
- TradingView compile and visual validation pending.
