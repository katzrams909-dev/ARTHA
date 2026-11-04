# ARTHA v2 P17.27 — Structural OTE Shadow Model

## Status
Committed to GitHub; TradingView compilation and chart/replay validation pending. Based on compile-confirmed P17.26.5.1. No production entry signal changes.

## Purpose
Introduce a lightweight, observational Optimal Trade Entry (OTE) band associated with causally confirmed external structure breaks and qualified displacement. Do not permit shadow OTE events to create live REV/CONT/EARLY/MISS entries, risk plans or alerts. The midpoint shadow audit remains present.

## Origin and confirmation
- Use the existing external structure events xBullBreak / xBearBreak, which are confirmed on barstate.isconfirmed, optionally require same-direction qualified bullish/bearish displacement (G14C default ON).
- Origin is the existing last confirmed opposite-direction external swing price xLow for bullish breaks, xHigh for bearish breaks. The opposite anchor is the confirming break candle's high/low. Both levels are frozen at break confirmation. Do not extend the break-candle extreme based on future prices.
- Require positive, correct-direction geometry and a minimum external pivot-to-break range (default >= 1.0 ATR). Rejected geometry/insufficient range is counted.
- Bullish band: high - (high - confirmed pivot low) * [0.62, 0.79]; bearish band: low + (confirmed pivot high - low) * [0.62, 0.79]. The 70.5% reference is derived using 0.705 of the same fixed range.
- The break/creation candle is excluded from OTE touch counting. Evaluate later confirmed candle ranges only, bounded by an observation window of 35 bars (configurable).

## Observations
- Count qualified locked OTE ranges, first 62–79% band touch, first 70.5% touch, OTE band overlap with an active same-direction unified POI at break confirmation, first OTE touches that had such POI confluence, and ranges expired without touching.
- Overlap means price intervals intersect; not equal to a matching POI 50% midpoint. The POI is checked at range creation, not retroactively with future POI data. Existing native OB/BB/FVG/IFVG qualification is unchanged.
- Keep at most 80 OTE range records by default. The table reports cap evictions. Existing counters remain historical through script execution but an evicted unresolved range can no longer accrue a later touch.
- Optional compact OTE audit table under group 14C, OFF by default, at top-left of chart. All OTE data is observational; no OTE chart boxes or trade entry labels.

## Caveats
- This is one conservative definition of an OTE dealing range: opposite confirmed external pivot to structural break confirmation extreme. It does not attempt to identify the ultimate final high/low of the entire impulse, since that would require later confirmation and potentially repaint a historical entry.
- A valid OTE band is NOT a proof of profitable institutional order placement. No OTE hypothetical limit fills, 1R outcome backtest, lower-timeframe execution sequence or realized profitability are claimed in P17.27.
- The structural break's source pivots are confirmed with their original lookback delay. Results are causal from the confirmation bar onward; the historical pivot origin is a prior confirmed observation, not an entry at that time.
- The OTE observational window can include later changes of the original POI. Confluence is locked at the structural break; it is not dynamically revised.
- The default required displacement+external break can yield fewer ranges; disable only for controlled sensitivity comparisons.
- P17.26.5.1 was near the Pine token budget. P17.27 adds a compact OTE section; source-level review is not a compiler guarantee. TradingView may report CE10117, in which case use a further compact patch rather than altering native trade logic.

## Testing
1. Compile P17.27 on TradingView Pine v6. Report exact error and line or compiled-token total.
2. Set G14C Enable OTE shadow ON and Show OTE shadow dashboard ON; test AUDUSD 5m, 15m, 1H alongside NAS100/US30.
3. For a detected bullish break, confirm the locked 0.62–0.79 band lies beneath the break high and above the selected confirmed external pivot low. For a bearish break, band lies above the break low and below the confirmed external pivot high.
4. Confirm zero same-creation-bar OTE hits. All touches are counted only on later confirmed bars and only once per range.
5. Verify confluence matches same-direction active POI overlap at the range creation bar; no later POI is silently retroactively included.
6. Compare all existing REV/CONT/EARLY/MISS labels, entry prices, structural stops and targets against P17.26.5.1 on matching closed candles. There should be no strategy changes.
7. Check active range count, expiry count and any cap evictions. For reliable comparisons, use identical symbol/timeframe/history and input presets.

## Next development gate
If P17.27 compiles and produces sensible anchors, the next study can assign OTE entry-candidate reasons and compare OTE + POI confluence against the existing midpoint-reclaim study on matched historical windows. Keep all models shadow-only until fill and risk assumptions have been validated.