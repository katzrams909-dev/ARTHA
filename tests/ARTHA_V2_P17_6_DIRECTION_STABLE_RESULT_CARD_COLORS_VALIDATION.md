# ARTHA v2 P17.6 — Direction-Stable Result Card Colors Validation

Target:

`pine/v2/ARTHA_V2_P17_6_Direction_Stable_Result_Card_Colors.pine`

## Compile
- [ ] Pine Script v6 compiles without errors.
- [ ] Confirm P17.5 inputs and signal logic remain intact.

## Recent-entry result-card colors
- [ ] Active BUY card uses the configured bullish signal color.
- [ ] BUY card remains bullish-colored after `STOPPED`, including a negative realized R.
- [ ] BUY card remains bullish-colored after `T2 HIT`.
- [ ] Active SELL card uses the configured bearish signal color.
- [ ] SELL card remains bearish-colored after `STOPPED`, including a negative realized R.
- [ ] SELL card remains bearish-colored after `T2 HIT`.
- [ ] Expired BUY/SELL cards retain their respective direction colors.
- [ ] Status and realized-R text still update correctly.

## Regression
- [ ] Stop-loss line/label uses the configured stop-loss color while the plan is active.
- [ ] Terminal risk lines and per-trade labels are still removed.
- [ ] Recent-entry card retention count still works.
- [ ] P17.4 direction arbitration and context-aware reaction POI selection remain unchanged.
- [ ] Check EURUSD 5m and NAS100 5m.

## Status
- Source and documentation committed to branch `artha-v2-p17-presets`.
- TradingView compile and visual checks remain pending until tested in TradingView.
