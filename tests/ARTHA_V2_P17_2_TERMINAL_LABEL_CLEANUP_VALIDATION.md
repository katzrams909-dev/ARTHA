# ARTHA v2 P17.2 — Terminal Label Cleanup Validation

Target:

`pine/v2/ARTHA_V2_P17_2_Terminal_Label_Cleanup.pine`

## Compile
- [ ] Pine v6 compiles without errors.
- [ ] No RiskPlan field/constructor mismatch.

## STOPPED case
- [ ] After a CONT trade stops, its BUY/SELL marker disappears.
- [ ] Its entry/detail label disappears.
- [ ] Its status label does not remain ACTIVE.
- [ ] Its SL/T1/T2 text labels disappear.
- [ ] Its recent result card remains, e.g. `STOPPED · -1.00R`.

## Other terminal outcomes
- [ ] T2 HIT removes that plan's per-trade labels.
- [ ] EXPIRED removes that plan's per-trade labels.
- [ ] Other active trade labels remain visible.
- [ ] REV and CONT plans both clean up their own labels at terminal outcome.

## Regression
- [ ] T1 marker cleanup behavior remains unchanged.
- [ ] Risk lines still obey `Show terminal risk plans`.
- [ ] Recent result cards and P16 attribution still update.
- [ ] Entry, stop, target, and realized-R values match P17.1.
- [ ] Check EURUSD 5m and NAS100 5m.
