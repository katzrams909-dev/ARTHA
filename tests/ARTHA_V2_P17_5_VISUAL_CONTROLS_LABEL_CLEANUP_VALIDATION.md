# ARTHA v2 P17.5 — Visual Controls & Label Cleanup Validation

Target:

`pine/v2/ARTHA_V2_P17_5_Visual_Controls_Label_Cleanup.pine`

## Compile
- [ ] Pine v6 compiles without errors.
- [ ] New input declarations compile.

## Color controls
- [ ] Bullish plan T1/T2 lines and labels use the chosen bullish TP color.
- [ ] Bearish plan T1/T2 lines and labels use the chosen bearish TP color.
- [ ] SL lines and labels use the chosen SL color.
- [ ] Changing colors does not affect calculations or signals.

## Label behavior
- [ ] With `Show REV/CONT BUY/SELL in entry label` off, entry label shows entry price and POI/episode reference without family/direction/score header.
- [ ] Turning it on restores the identity/source/quality header.
- [ ] `Show active plan status tag` independently controls the separate ACTIVE/T1 status label.
- [ ] Recent result cards retain family, direction, source and outcome.
- [ ] Terminal trades still delete their per-trade risk lines and labels.

## Regression
- [ ] P17.4 direction arbitration and context-aware reaction POI selection remain unchanged.
- [ ] Check EURUSD 5m and NAS100 5m.
