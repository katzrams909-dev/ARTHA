# ARTHA v2 P15.1 — Target Ordering Validation

Target:

`pine/v2/ARTHA_V2_P15_1_Target_Ordering_Hotfix.pine`

## Compile
- [ ] Pine v6 compiles without errors.
- [ ] CE10295 does not return.

## Guaranteed ordering
- [ ] bullish T2 is always above bullish T1.
- [ ] bearish T2 is always below bearish T1.
- [ ] minimum configured T1/T2 separation is respected.
- [ ] at least one tick separates T1/T2 even when ATR separation is zero.

## Liquidity search
- [ ] nearest valid T1 is selected.
- [ ] invalid second liquidity does not prevent later valid liquidity from becoming T2.
- [ ] T2 respects minimum T2 R.
- [ ] T2 respects maximum liquidity-target R.
- [ ] target tier filter remains active.

## Fallback
- [ ] normal 1.5R / 2.5R fallback remains when appropriate.
- [ ] if liquidity T1 is beyond 2.5R, fallback T2 moves beyond T1 instead of behind it.
- [ ] stop placement is unchanged.

## Regression
- [ ] NORMAL signals unchanged.
- [ ] MISS signals unchanged.
- [ ] EARLY signals unchanged.
- [ ] P14 conflict resolution unchanged.
- [ ] outcomes unchanged.
- [ ] last-four entry/result cards unchanged except input wording.

## Smoke test
- [ ] NAS100 5m.
- [ ] XAUUSD 5m.
- [ ] EURUSD 5m.
- [ ] GBPUSD 5m.
