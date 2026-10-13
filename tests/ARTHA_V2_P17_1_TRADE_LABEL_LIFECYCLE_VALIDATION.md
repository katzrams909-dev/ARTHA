# ARTHA v2 P17.1 — Trade Label Lifecycle Validation

Target:

`pine/v2/ARTHA_V2_P17_1_Trade_Label_Lifecycle.pine`

## Compile
- [ ] Pine v6 compiles without errors.
- [ ] No type/constructor argument mismatch after adding `RiskPlan.signalMarker`.

## Marker association
- [ ] Compact Execution CONT BUY marker links to the correct RiskPlan.
- [ ] Compact Execution CONT SELL marker links to the correct RiskPlan.
- [ ] Verbose Analysis/Full CONT BUY marker links correctly.
- [ ] Verbose Analysis/Full CONT SELL marker links correctly.
- [ ] Marker matching uses family, direction, and signal bar.

## Lifecycle
- [ ] CONT marker disappears on T1 HIT.
- [ ] CONT marker disappears on T2 HIT.
- [ ] CONT marker disappears on STOPPED.
- [ ] CONT marker disappears on EXPIRED.
- [ ] Unrelated active CONT markers remain visible.
- [ ] REV marker behavior remains unchanged.
- [ ] Disabling `Remove CONT marker after first TP/SL` preserves CONT markers.

## Regression
- [ ] Entry/SL/T1/T2 prices unchanged from P17.
- [ ] P16 attribution unchanged.
- [ ] Recent entry-result cards still update.
- [ ] `Show terminal risk plans` behavior unchanged.
- [ ] Check NAS100 5m and XAUUSD 5m in Execution mode.
