# ARTHA v2 P13 — Target Quality Validation

Target: `pine/v2/ARTHA_V2_P13_Target_Quality_Engine.pine`

## Compile
- [ ] Pine v6 compiles without errors.
- [ ] CE10295 does not return.

## Liquidity target quality
- [ ] tier 4 ignored with default max tier 3.
- [ ] liquidity below 0.75R is not used as T1.
- [ ] liquidity beyond 5R is not used by default.
- [ ] T2 requires at least 1.50R.
- [ ] T2 is separated from T1 by at least 0.20 ATR.
- [ ] T2 is always beyond T1 in trade direction.

## Fallback
- [ ] missing T1 liquidity → 1.50R fallback.
- [ ] missing/invalid T2 liquidity → 2.50R fallback.
- [ ] fallback does not change stop placement.

## Regression
- [ ] NORMAL signals unchanged.
- [ ] MISS signals unchanged.
- [ ] EARLY signals unchanged.
- [ ] recent-entry cards unchanged.

## Smoke test
- [ ] NAS100 5m: compare previous 7R–9R targets.
- [ ] XAUUSD 5m.
- [ ] EURUSD 5m.
- [ ] GBPUSD 5m.
