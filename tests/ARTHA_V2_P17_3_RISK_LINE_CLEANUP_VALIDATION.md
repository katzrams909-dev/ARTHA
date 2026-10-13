# ARTHA v2 P17.3 — Risk Line Cleanup Validation

Target:

`pine/v2/ARTHA_V2_P17_3_Risk_Line_Cleanup.pine`

## Compile
- [ ] Pine v6 compiles without errors.
- [ ] No reference remains to the removed `showTerminalRiskPlans` input.

## Terminal cleanup
- [ ] STOPPED deletes entry, SL, T1 and T2 lines.
- [ ] T2 HIT deletes entry, SL, T1 and T2 lines.
- [ ] EXPIRED deletes entry, SL, T1 and T2 lines.
- [ ] Terminal cleanup occurs for both REV and CONT plans.
- [ ] Historical result card remains visible.
- [ ] No bare terminal risk lines remain after script reload.

## Active plans and regression
- [ ] Active trade lines remain visible.
- [ ] A separate active trade is not affected when another plan terminates.
- [ ] Preset selector still works.
- [ ] Signal counts and outcome attribution remain unchanged.
- [ ] Check EURUSD 5m and NAS100 5m.
