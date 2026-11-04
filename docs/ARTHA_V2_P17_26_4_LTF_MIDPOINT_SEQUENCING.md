# ARTHA P17.26.4 — Lower-Timeframe Midpoint Execution Sequencing

## State
Committed to GitHub branch artha-v2-p17-presets. This version has NOT been compiled or replay-tested by the user in TradingView. P17.26.3 is the latest validated baseline. No live strategy signals are added.

## Source foundation
Derived from pine/v2/ARTHA_V2_P17_26_3_Pre_Lifecycle_POI_Snapshot.pine. Previous-close snapshotting, source ID/phase de-duplication, independent midpoint/reclaim shadow trials, stable native POI lifecycles and all existing REV/CONT/EARLY/MISS/risk plans remain unchanged.

## New G14B inputs
- Use lower timeframe sequencing for shadow audit: ON.
- Inspection timeframe: 1 minute by default. On a 1-minute chart (or when the chosen timeframe is not strictly lower) the LTF sequencing is bypassed and the OHLC fallback remains.
- All pre-existing midpoint shadow audit inputs are retained.

## Mechanics
- On the previous confirmed bar, snapshot the relevant OB/BB/FVG/IFVG phase, midpoint, direction, boundaries, and frozen hypothetical stop and 1R target using the prior-close ATR. This corrects prior versions' use of the touch-bar ATR for hypothetical orders.
- A midpoint trial is eligible only on later bars, as in P17.26.3. A candle must span the midpoint with its high-low range. No new POI source or inversion phase is allowed to fill on its own creation candle.
- TradingView request.security_lower_tf returns chronological arrays of available lower-timeframe OHLC bars. The audit steps through them in timestamp order to find the first midpoint interaction, then which boundary is encountered first on subsequent intrabars.
- If an LTF bar opens beyond the expected limit or reaches either stop or 1R in the same intrabar as its first midpoint interaction, classify as UNCERTAIN. If both boundaries are hit in one later LTF bar, also UNCERTAIN.
- If the stop or 1R first occurs in a distinct later intrabar, record its order from the LTF sequence. This improves sequencing resolution but is not proof of a broker fill.
- When no LTF data is available, use the existing P17.26.3 conservative chart-OHLC evaluation, with same-candle outcomes uncertain where sequencing is unknown.
- If an available LTF array does not account for a stop or target that is present in chart OHLC, mark the trial uncertain instead of ignoring the discrepancy.
- Ongoing open midpoint trials and separate confirmed-reclaim close-entry shadow trials use available LTF ordering for their stop/1R outcomes; both remain observational and maintain independent histories and timeouts.
- The dashboard (row 15-16) adds LTF first-touch resolved (verified ordering across distinct intrabars), LTF first-touch uncertain, LTF unavailable and LTF inspected counts.

## Important limitations
- Lower-timeframe data is still OHLC, not tick-by-tick bid/ask transactions. Same-LTF-candle event order is unknowable and classified uncertain.
- Intrabar data availability depends on the user's TradingView subscription, date/time, market provider, available LTF trading history and request limits. TradingView may return empty arrays for older chart bars. Output should not be treated as a guaranteed backtest across all history.
- Historical/realtime lower-TF feeds can be revised by vendors, so source LTF studies should be compared after chart reload. Lower-TF data does not guarantee non-repainting across feed changes.
- A 1m inspection on a 5m chart is still coarse; LTF bars with multiple boundary touches remain ambiguous. This code does not use a TradingView strategy broker emulator, Bar Magnifier, spread, fees, order book or tick stream.
- An LTF array may have partial market coverage. Chart-LTF extreme disagreements are flagged uncertain when a boundary would otherwise be omitted; this is not a complete gap detection system.
- If the chart bar gaps entirely past the midpoint without spanning it, the existing shadow crossing criterion does not mint a trial. Such gaps should be separately modeled before authorizing any real midpoint limit orders.
- The sample remains restricted to source POIs present in the prior-close unified registry, not a theoretical full historical market replay. Native registry and object limits remain in place.
- The fallback 1R model does not replicate production structural SL/TP1–TP4; it is an exploratory, single-target shadow outcome.

## Acceptance protocol
1. Compile the P17.26.4 Pine source in TradingView; report the first exact compiler error and line if any.
2. Set G14B inspection timeframe 1m and enable the shadow table; test AUDUSD, US30, SPX500 on 5m, 15m, 1H. Do NOT interpret results as comparable unless market, interval and history match.
3. Confirm the LTF inspected count is nonzero and matches the number of first touches with accessible LTF bars. Check LTF unavailable and LTF uncertain separately.
4. Compare identical replay segments with LTF sequencing ON versus OFF. LTF ON should only change shadow statistics and must not alter production REV/CONT/EARLY/MISS labels, POI states or risk plans.
5. Verify frozen midpoint/SL/1R levels are attached to the previous confirmed POI snapshot. A touch-bar ATR change must not alter a frozen hypothetical trade.
6. Validate that 1R cannot be credited if stop and target ordering is not decidable from distinct available intrabars.
7. Confirm completed midpoint/reclaim histories are bounded, no capacity skip is being hidden, and phase keys are not recycled.
8. Once P17.26.4 is validated, consider P17.27 OTE shadow study with confirmed causal impulse anchors and optional POI overlap, still without live entry changes.

## Reference
TradingView official Pine Script v6 documentation: https://www.tradingview.com/pine-script-docs/concepts/other-timeframes-and-data/ . See request.security_lower_tf, tuple-array ordering and data coverage limitations.