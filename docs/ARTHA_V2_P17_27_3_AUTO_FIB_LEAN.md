# ARTHA v2 P17.27.3 — Auto Fib Lean / CE10117 Reduction

## Status
Committed to branch `artha-v2-p17-presets`, **TradingView compile and chart checks pending**. User reported P17.27.2 at 101,800 compiled tokens versus a 100,256 limit (CE10117), and requested removal of the unnecessary shadow diagnostics.

## Source reduction
- Based on P17.27.2, not a wholesale rewrite.
- Removed the complete section `14B Midpoint Shadow Audit` inputs, shadow trial types, observation arrays and maps, previous-bar shadow snapshots, `request.security_lower_tf` call, hypothetical 1R/reclaim outcome classifier and midpoint audit dashboard.
- Removed OTE shadow diagnostics table/input and OTE statistics counters. Kept the minimal OTE confirmed-range lifecycle because Auto Fib depends on it.
- Preserved bounded `oteRanges` with frozen confirmed structural source origin and break-candle extreme, 62–79% band and 70.5% midpoint, expiry and retention caps, and optional same-direction native POI overlap metadata.
- Preserved Auto Fib 0%, 50%, 62%, 70.5%, 79%, 100% lines and shaded zone; Latest/Historical selection (up to five) and drawing-pool cleanup. Overlay stays OFF by default until enabled in 14C.
- OTE update and Auto Fib renderer remain in functions, limiting top-level body growth.

## Preserved
Native OB/BB/FVG/IFVG source qualification, mitigation/inversion visual end states, existing entry selection and arbitration for REV/CONT/EARLY/MISS, structural stop and TP1–TP4 plans, risk visuals and independent managed plans. No midpoint limit orders, OTE production entries, or VWAP.

## What no longer exists in this version
Midpoint shadow experimental statistics; historical OHLC vs LTF 1R study; shadow reclaim comparisons; prior-close POI audit snapshots; OTE dashboard counters. All older versions remain available in GitHub for comparative research.

## Caveats
- Source dropped from roughly 231,339 to 209,393 characters, but Pine compiled tokens are not proportional to characters. TradingView must verify CE10117 is cleared.
- No attempt was made to change signal logic or convert the indicator to a strategy.
- The OTE Auto Fib draws only retained structural-break anchored ranges; historical mode does not resurrect expired ranges.

## Validation
1. Compile P17.27.3. Report first error code and compiled-token total if any.
2. Set `Enable OTE shadow observations` ON and `Show Auto Fib overlay` ON in section 14C; start with Latest mode.
3. Confirm correct 0/50/62/70.5/79/100 price levels, both long and short; verify anchors remain frozen after the break confirmation.
4. Compare native OB/BB/FVG/IFVG and original REV/CONT/EARLY/MISS labels, structural SL and TP1–TP4 against last confirmed production baseline on the same chart range.
5. Test Historical mode 1–5, OTE expiration, bounded drawing objects and visual clutter.
6. If CE10117 persists, use the exact remaining token count to choose the next isolated reduction; avoid touching validated entry and risk engines.