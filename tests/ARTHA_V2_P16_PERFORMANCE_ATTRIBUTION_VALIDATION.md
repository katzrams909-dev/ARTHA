# ARTHA v2 P16 — Performance Attribution Validation

Target:

`pine/v2/ARTHA_V2_P16_Performance_Attribution.pine`

## Compile
- [ ] Pine v6 compiles without errors.
- [ ] CE10295 does not return.

## Regression
- [ ] Signal locations match P15.1.
- [ ] NORMAL signals unchanged.
- [ ] MISS signals unchanged.
- [ ] EARLY signals unchanged.
- [ ] P14 conflict priority unchanged.
- [ ] P15.1 targets unchanged.
- [ ] Stops unchanged.
- [ ] outcomes unchanged.

## Metadata
- [ ] RiskPlan stores setup score.
- [ ] RiskPlan stores setup grade.
- [ ] metadata remains correct when risk drawings are disabled.

## Family/source attribution
- [ ] REV NORMAL closes increment REV · NORMAL only.
- [ ] REV MISS closes increment REV · MISS only.
- [ ] REV EARLY closes increment REV · EARLY only.
- [ ] CONT NORMAL closes increment CONT · NORMAL only.
- [ ] CONT MISS closes increment CONT · MISS only.
- [ ] CONT EARLY closes increment CONT · EARLY only.

## Grade attribution
- [ ] each realized outcome increments exactly one grade bucket.
- [ ] A/B/C/D use the score thresholds already defined by the production quality engine.
- [ ] expired plans do not affect realized-R attribution.

## Table
- [ ] table OFF produces no chart clutter.
- [ ] table ON renders 10 attribution rows.
- [ ] closed/win/loss totals update correctly.
- [ ] win rate shows only after configured minimum sample.
- [ ] Total R and Avg R update correctly.

## Smoke test
- [ ] NAS100 5m.
- [ ] XAUUSD 5m.
- [ ] EURUSD 5m.
- [ ] GBPUSD 5m.
