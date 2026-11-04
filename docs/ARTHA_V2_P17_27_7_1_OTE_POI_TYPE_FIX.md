# ARTHA P17.27.7.1 — CE10123 Constructor Alignment

## Report
TradingView rejected P17.27.7: `Cannot call "OTEShadowRange.new" with argument "qualifiedTouch"="". An argument of "literal string" type was used but a "series bool" is expected` (CE10123).

## Cause
P17.27.7 extended the OTEShadowRange type with `bool qualifiedTouch` and `string matchedPOIType`. The structural-break constructor passed all fields, but the swing-source constructor in `f_storeAutoFibRange` included only three trailing Boolean arguments rather than four. Consequently the empty string intended for `matchedPOIType` shifted into `qualifiedTouch`.

## Fix
Change the swing constructor's trailing arguments from `false,false,false,""` to `false,false,false,false,""`. The source now supplies the correct fields in order:
- `poiOverlap=false`
- `touched=false`
- `hit705=false`
- `qualifiedTouch=false`
- `matchedPOIType=""`

The structural-break constructor was already correct; its arguments remain unchanged. P17.27.7.1 is a separate version and does not change native POIs, OTE eligibility logic, first-touch classification, Fibonacci lifecycle or production signal/risk behavior.

## Status and test
GitHub source committed. **TradingView compile confirmation pending.** Load P17.27.7.1, compile, and report the first remaining compiler error (if any), then verify the POI statuses for Minor/Major/Break Fib sources against the P17.27.6.1 confirmed working baseline.
