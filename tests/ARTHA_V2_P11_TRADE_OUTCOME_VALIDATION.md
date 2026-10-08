# ARTHA v2 P11 — Trade Outcome Validation

Target: `pine/v2/ARTHA_V2_P11_Trade_Outcome_Tracking.pine`

## Compile

- [ ] Pine v6 compiles without errors.
- [ ] P01–P10.1 behavior remains unchanged.

## Lifecycle

- [ ] ACTIVE plan can transition to T1_HIT.
- [ ] T1_HIT remains non-terminal.
- [ ] T2_HIT terminates plan.
- [ ] STOPPED terminates plan.
- [ ] EXPIRED terminates plan.
- [ ] terminal plan is recorded only once.

## Conservative precedence

Construct/observe a bar touching both stop and target:

- [ ] STOPPED is recorded rather than an optimistic target result.

## No partial model

- [ ] T2_HIT realizes RR2.
- [ ] STOPPED realizes -1R.
- [ ] EXPIRED does not enter realized-R totals.

## 50% T1 + BE remainder

- [ ] stop before T1 = -1R.
- [ ] stop after T1 = 0.5 × RR1.
- [ ] T2 = 0.5 × RR1 + 0.5 × RR2.
- [ ] expired remains excluded.

## Statistics

- [ ] cumulative R equals sum of terminal non-expired results.
- [ ] average R denominator excludes expired.
- [ ] REV metrics only use REV plans.
- [ ] CONT metrics only use CONT plans.
- [ ] win rate uses realized R > 0 as win.

## Visual cleanliness

- [ ] outcome labels are hidden by default.
- [ ] enabling labels does not create infinite lines.
- [ ] label count stays bounded.
- [ ] P10.1 active risk-plan lifecycle remains clean.

## Reload determinism

After reload:

- [ ] terminal outcomes occur on the same bars.
- [ ] total realized R is unchanged.
- [ ] REV/CONT metrics are unchanged.

## Exit gate

Do not convert to a TradingView strategy until P11 outcome accounting is validated visually and numerically.
