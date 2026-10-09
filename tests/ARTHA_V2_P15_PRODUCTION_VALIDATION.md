# ARTHA v2 P15 — Production Validation

Target: `pine/v2/ARTHA_V2_P15_Production_Consolidation.pine`

## Compile
- [ ] Pine v6 compiles without errors.
- [ ] CE10295 does not return.

## Signal regression
- [ ] NORMAL REV works.
- [ ] NORMAL CONT works.
- [ ] MISS works.
- [ ] EARLY works.
- [ ] RAW remains ignored.
- [ ] P14 priority NORMAL > MISS > EARLY remains intact.
- [ ] opposite-direction signals remain independent.

## Targets
- [ ] P13 liquidity target filters unchanged.
- [ ] fallback T1/T2 unchanged.
- [ ] stop placement unchanged.

## Display/calculation separation
- [ ] hide structure visuals: signals unchanged.
- [ ] hide FVG/IFVG visuals: signals unchanged.
- [ ] hide OB/BB visuals: signals unchanged.
- [ ] hide liquidity visuals: signals unchanged.
- [ ] hide execution markers: risk plans/outcomes unchanged.
- [ ] switch Execution/Analysis/Full: calculations unchanged.

## History / lifecycle
- [ ] last 4 entry/result cards retained.
- [ ] newest active plan displays correctly.
- [ ] internal risk-plan tracking remains bounded.
- [ ] signal-history retention remains bounded.
- [ ] old lines/labels/boxes delete cleanly.

## Alerts
- [ ] normal REV/CONT fires one family execution alert.
- [ ] MISS/ EARLY promoted signal fires one family execution alert, not duplicate generic reaction alert.
- [ ] risk-plan alert works.
- [ ] outcome alert works.

## Smoke test
- [ ] NAS100 5m.
- [ ] XAUUSD 5m.
- [ ] EURUSD 5m.
- [ ] GBPUSD 5m.
