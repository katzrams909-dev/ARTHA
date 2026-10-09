# ARTHA v2 P14 — Signal Conflict Validation

Target: `pine/v2/ARTHA_V2_P14_Signal_Conflict_Resolution.pine`

## Compile
- [ ] Pine v6 compiles without errors.
- [ ] CE10295 does not return.

## Priority
- [ ] EARLY → NORMAL inside conflict window: NORMAL allowed.
- [ ] NORMAL → EARLY inside conflict window: EARLY blocked.
- [ ] EARLY → MISS inside conflict window: MISS allowed.
- [ ] MISS → EARLY inside conflict window: EARLY blocked.
- [ ] MISS → NORMAL inside conflict window: NORMAL allowed.
- [ ] NORMAL → MISS inside conflict window: MISS blocked.
- [ ] same priority inside window: second signal blocked.
- [ ] same source outside window: later signal may be allowed.

## Direction
- [ ] bullish conflict state does not block bearish signal.
- [ ] bearish conflict state does not block bullish signal.

## Regression
- [ ] P12.7 EARLY frequency control still works.
- [ ] P13 target-quality engine unchanged.
- [ ] risk plans unchanged.
- [ ] last-four result cards unchanged.

## Smoke test
- [ ] NAS100 5m.
- [ ] XAUUSD 5m.
- [ ] EURUSD 5m.
- [ ] GBPUSD 5m.
