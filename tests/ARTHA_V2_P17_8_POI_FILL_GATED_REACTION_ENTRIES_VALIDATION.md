# ARTHA v2 P17.8 — POI Fill-Gated Reaction Entries Validation

Target: `pine/v2/ARTHA_V2_P17_8_POI_Fill_Gated_Reaction_Entries.pine`

## Compile and regression
- [ ] Pine Script v6 compiles in TradingView.
- [ ] P17.7 remains unchanged.
- [ ] Confirmation window defaults to 5 bars and remains configurable 1–5.
- [ ] EARLY minimum delay remains 1 bar after the fill-trigger bar by default.
- [ ] Normal REV/CONT entry engine, SL/TP geometry, and outcome accounting are unchanged.

## Fill thresholds
- [ ] Default threshold is 50%.
- [ ] 25% option triggers only once the selected POI is penetrated by at least one quarter.
- [ ] 50% option triggers only at midpoint penetration or deeper.
- [ ] 75% option triggers only at three-quarter penetration or deeper.
- [ ] 100% option triggers only when price reaches/passes the far POI edge.
- [ ] 100% + Sweep requires price to trade strictly beyond the far POI edge.
- [ ] Bullish and bearish thresholds are mirrored correctly.
- [ ] Fill depth is calculated from wick extremes, not candle close.
- [ ] Once threshold is reached, the reaction confirmation window starts on that bar.
- [ ] For 100% + Sweep, the existing sweep-reclaim confirmation must still pass.
- [ ] Invalid/retired POIs do not produce entries.

## Visual test
- [ ] Test the same chart windows in P17.7 and P17.8.
- [ ] Compare 25%, 50%, 75%, 100%, and 100% + Sweep using the same symbol/timeframe.
- [ ] Record entry depth, direction correctness, late/missed entries, and subsequent reaction quality.
- [ ] Confirm NORMAL signals are unaffected.

## Status
- Source and docs committed to `artha-v2-p17-presets`.
- TradingView compile and visual validation pending.
