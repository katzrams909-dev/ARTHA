# ARTHA v2 P17.10 — Stop/Target Validation

Target: `pine/v2/ARTHA_V2_P17_10_Structural_Stop_Target_Risk_Controls.pine`

## Compile and regression
- [ ] Compiles in TradingView as Pine Script v6.
- [ ] P17.9 remains unchanged.
- [ ] POI fill dropdown and reaction confirmation behavior remain unchanged.
- [ ] Existing Causal / POI edge / Protected swing stop models remain available.

## Stop cap
- [ ] Default maximum stop distance is 3.00 ATR.
- [ ] A stop at or below the cap is accepted.
- [ ] A stop beyond the cap rejects the plan without pulling the structural stop inward.
- [ ] A rejected plan's execution alert is suppressed and its signal marker is removed.
- [ ] A rejected plan does not clear drawings from a previously active plan.
- [ ] Test both bullish and bearish REV/CONT signals.

## Targets
- [ ] T1 fallback respects minimum T1 R and leaves room for T2 separation.
- [ ] T1 liquidity target leaves enough room for T2 within the maximum target-R bound.
- [ ] T2 liquidity target respects direction, minimum T2 R, separation, and maximum target R.
- [ ] T2 fallback is beyond T1 by the configured separation and never exceeds maximum target R.
- [ ] If valid T1/T2 geometry cannot fit inside the maximum R bound, the plan is rejected.
- [ ] Test presets with different maximum target R values.

## Partial T1 and breakeven
- [ ] With `50% T1 + BE remainder`, T1 hit moves the stop line and stop tag to entry.
- [ ] A later breakeven stop realizes 0.5 × T1 R.
- [ ] T2 hit realizes 0.5 × T1 R + 0.5 × T2 R.
- [ ] Expiry after T1 records the partial T1 return and assumes the remainder is flat at breakeven.
- [ ] With `No partial`, the stop is not moved after T1.
- [ ] Same-bar stop precedence remains conservative.

## Status
- [ ] TradingView compile confirmed by user.
- [ ] Visual tests confirmed by user.
