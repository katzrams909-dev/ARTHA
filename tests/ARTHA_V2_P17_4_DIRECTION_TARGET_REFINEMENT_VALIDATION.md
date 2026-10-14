# ARTHA v2 P17.4 — Direction & Target Refinement Validation

Target:

`pine/v2/ARTHA_V2_P17_4_Direction_Target_Refinement.pine`

## Compile
- [ ] Pine v6 compiles without errors.
- [ ] `SignalRecord` constructors include source and priority fields.
- [ ] No undeclared identifier or constructor/type errors in arbitration.

## Direction integrity
- [ ] Bullish REV produces REV BUY plan with bullish POI provenance.
- [ ] Bearish REV produces REV SELL plan with bearish POI provenance.
- [ ] Bullish CONT produces CONT BUY plan with bullish POI provenance.
- [ ] Bearish CONT produces CONT SELL plan with bearish POI provenance.
- [ ] MISS and EARLY plans retain the correct family, direction and POI.
- [ ] When normal and reaction candidates conflict on the same bar, only the selected candidate remains.
- [ ] Equal top-ranked opposing-direction candidates produce no risk plan and no stray signal markers.
- [ ] Signal counters and conflict state remain consistent after arbitration.

## Missed-entry selection
- [ ] If a candle touches both an unrelated RAW POI and a POI matching an active REV/CONT candidate, the candidate-linked POI is selected.
- [ ] Recent aligned context outranks a touched POI with no context.
- [ ] RAW-only touches do not become execution signals.
- [ ] Confirmation still requires a confirmed bar and configured reaction confirmation.

## Colors
- [ ] Bullish T1/T2 lines and labels use the bullish signal color.
- [ ] Bearish T1/T2 lines and labels use the bearish signal color.
- [ ] SL lines and labels are grey.
- [ ] Entry line and terminal cleanup remain unchanged.

## Regression
- [ ] Preset selector still works.
- [ ] Active risk plans retain drawings.
- [ ] T2/STOP/EXPIRED removes per-trade lines and labels.
- [ ] Result cards and performance attribution still update.
- [ ] Check EURUSD 5m, NAS100 5m, and XAUUSD 5m.
