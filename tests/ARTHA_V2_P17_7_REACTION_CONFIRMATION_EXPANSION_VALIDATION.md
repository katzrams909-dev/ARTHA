# ARTHA v2 P17.7 — Reaction Confirmation Expansion Validation

Target: `pine/v2/ARTHA_V2_P17_7_Reaction_Confirmation_Expansion.pine`

## Compile and regression
- [ ] Pine Script v6 compiles without errors in TradingView.
- [ ] P17.6 visual controls and direction-stable recent result-card colors remain intact.
- [ ] NORMAL signal logic, signal arbitration, risk geometry, and outcome accounting are unchanged.

## Confirmation window
- [ ] Default reaction confirmation window is 5 bars.
- [ ] Input range is 1–5 bars.
- [ ] Deadline counts the POI-touch bar as bar 1.
- [ ] MISS can still confirm on the touch bar when `Allow touch-bar confirmation` is enabled.
- [ ] MISS cannot confirm on the touch bar when that setting is disabled.
- [ ] EARLY cannot confirm on the touch bar with the default minimum delay of 1.
- [ ] EARLY can confirm on a later closed candle inside the active confirmation window.
- [ ] Both bullish and bearish paths behave symmetrically.
- [ ] Confirmation expires after the configured window.
- [ ] A POI invalidation still cancels a pending reaction.

## Visual test
- [ ] Test EURUSD 5m and NAS100 5m.
- [ ] Compare the same chart regions in P17.6 and P17.7.
- [ ] Record correct-direction entries, wrong-direction entries, missed opportunities, stop-outs, T1 hits, T2 hits, and expiries.

## Separate review (not fixed by this version)
- [ ] Identify why reaction candidates are rejected or missed.
- [ ] Verify wrong-direction context handling.
- [ ] Audit stop selection and stop distance.
- [ ] Audit liquidity target selection, target ordering, and fallback R targets.

## Status
- Source and documentation are committed to `artha-v2-p17-presets`.
- TradingView compile and visual checks are pending; do not treat this version as validated until tested.
