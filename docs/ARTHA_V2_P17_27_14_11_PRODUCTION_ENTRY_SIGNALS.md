# ARTHA P17.27.14.11 — Production Entry Signals (No Observation Labels)

## User direction and baseline
User stated P17.27.14.10 is working, and requested: **"remove observations and return entry signals."** P17.27.14.10 is the last user-verified compiling version. P17.27.14.11 is committed, **not yet compiled or chart-tested in TradingView**.

## Changes
1. Removed the orange non-executable `POI 50%` reclaim-observation drawing and its `Show midpoint audit` input, per-POI audit dedup, orange audit label pool, and `M` dashboard metric. No observation-only label is emitted.
2. Kept the confirmed POI midpoint **touch/retest ledger**, because it is required by the executable MID entry route. This is live state for signal qualification, not observational drawing.
3. Production signal sources retained: NORMAL, EARLY, MISS, MID and independent OTE, all classified REV/CONT and subject to original quality, arbitration/deduplication, structural stops, max 3-ATR stop distance, TP1–TP4 and OTE confluence logic. **MID and independent OTE default to ON**, but remain user-toggleable.
4. The accepted-entry marker now stays anchored to the **actual entry candle**, rather than being deleted and replaced by a tag that floats rightward. With risk level tags enabled, its text is enriched with trade ID, REV/CONT, BUY/SELL, signal source, quality, entry price, native POI and reason. Normal active stop and target drawings remain.
5. An accepted signal marker is removed from the transient signal-label pruning pool and becomes tied to its independent risk plan so later candidates cannot prune an unrelated open plan's entry marker.
6. Removed CONT marker deletion after TP1. At terminal outcome, reuse the existing original-candle marker, append terminal TP/STOPPED and realized R, and move the same label into a bounded closed-marker pool. A fallback label is constructed at the original bar only when the original marker was unavailable.
7. Default `showRejectedSignalMarkers=false` and `showNormalUpgradeMarkers=false` so charts focus on **accepted entry** signals instead of observations/rejections/upgrade-only markers. Both settings remain available for debugging.
8. Removed the temporary signal-flow dashboard input and rows (POI/ELIGIBLE and SIGNAL FLOW), **restoring TP3/TP4 liquidity objectives** in those rows. Internal counters have not been rewritten.
9. Renamed the legacy input `Enable OTE shadow observations (no signals)` to `Track confirmed structural-break OTE anchors`. Its confirmation and archive logic remain necessary for production structural-break OTE signals.
10. All prior source versions remain unchanged.

## Technical behavior
- The MID/OTE per-POI ledger is populated only at confirmed chart closes and requires the POI to exist on earlier bars. Multi-candle midpoint touch/reclaim respects `normalConfirmBars`. Independent OTE also requires earlier-confirmed Fib archive, recorded confluence and overlapping pre-existing native POI.
- Signal bars are not backdated to the POI/Fib origin. Accepted entries occur at the qualifying current candle's close.
- The current risk plan remains the only source of accepted trade outcomes; **no rejected or observation-only markers are treated as trades**.
- The accepted marker's time coordinate is unchanged through its active and completed life; only its text is updated at completion.

## Verify in TradingView
1. Compile `pine/v2/ARTHA_V2_P17_27_14_11_Production_Entry_Signals.pine`; report exact CE/line if any. Earlier builds approached TradingView's 100256 compiled-token maximum.
2. Validate 15m GBPUSD, AUDUSD, USDCAD, USDJPY, NAS100, XAUUSD. The orange `POI 50%` observation labels must be **gone**.
3. Confirm accepted BUY/SELL REV/CONT markers appear **on the original signal candle** with NORMAL, EARLY, MISS, MID or OTE source and entry reason. No duplicate floating entry tag should appear. When TP1 is hit on CONT, the entry marker must remain.
4. Compare counts of accepted plans, rejected candidates and outcome R with P17.27.14.10 under same symbols/loaded history/presets. The observation layer's removal should not alter production qualification, except that MID and OTE are now **enabled by default**; compare with those toggles matching .14.10 for parity.
5. Verify stop side, <=3 ATR maximum distance, TP1/TP2 and visual TP3/TP4, and simultaneous independent POI trade plans. Confirm historical markers persist after TP or SL, and no backpaint using Bar Replay.
6. If the user wants to inspect non-executed opportunities later, use a separate diagnostic version rather than reinstating observation clutter in this production build.

## Status
GitHub committed; TradingView compile and chart acceptance pending. Rollback: P17.27.14.10.
