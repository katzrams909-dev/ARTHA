# ARTHA V2 — P17.27.14.12 Compact Execution Entry Labels

## Trigger
User shared 15-minute XAUUSD screenshots of P17.27.14.11 showing huge, overlapping red entry badges, especially OTE. User request: "look at the labels, they are too long."

## Visual changes only
- All accepted entry markers are now compressed to a tiny **two-line candle-anchored badge**, for example:
  ```text
  ▼ C OTE · Q91A
  P76 FVG#1149 @4109.445
  ```
  The first line shows direction ▲/▼, REV/CONT family (R/C), source (NORMAL/EARLY/MISS/MID/OTE), and quality. The second shows plan ID, POI type/ID, and entry price.
- A hover tooltip retains the **full trade reason** (Reversal/Continuation, native POI, episode ID, OTE source when applicable), stop, T1, T2 and respective R multiples.
- Removed the separate OTE source string previously appended to the on-chart entry text after admission (OTE scale detail remains in tooltip). This eliminates repeated `OTE` text.
- When trade completes, the same anchored badge receives a compact third line such as `TP2 +1.50R` or `SL -1.00R`. No additional historical-label copy is created.
- Shortened right-edge stop/target labels to tiny `SL 4090.425`, `T1 4056.502`, etc. TP3/TP4 levels remain as lines/labels.
- Marker style is a tiny up/down badge regardless of the initial signal's display mode, and the marker stays at the original signal candle and exact entry-price Y coordinate.

## Architecture preserved
- No changes to NORMAL, EARLY, MISS, MID or independent OTE qualification, score, priority or trade admission.
- Original candle non-repainting signal timing, causal structural stop, max 3 ATR stop, target geometry and TP1–TP4 retained.
- Independent simultaneous risk plans and accepted-key dedup are unchanged.
- All earlier versions kept intact; P17.27.14.11 is the last screenshot-confirmed working baseline.

## Validation
1. Compile `pine/v2/ARTHA_V2_P17_27_14_12_Compact_Entry_Labels.pine` in TradingView. Pine token budget near the limit; report the exact count if CE10117 arises.
2. Check XAUUSD 15m against the two screenshot examples. There should no longer be full-width red rectangles spanning candles with the entire trade description.
3. Hover a badge to inspect entry reason and price levels. Verify direction, entry class, score, POI, and prices.
4. Check a completed trade shows a concise TP/SL outcome below the badge rather than the full long description.
5. Compare P17.27.14.11 and P17.27.14.12 with identical input configurations; the accepted P#, price levels, structural risk, TP/SL and performance counters should not change.
6. Check trading alerts and original timestamp still align, and no duplicate entry labels appear.

## Status
Committed to GitHub; **not yet compile-verified in TradingView**.
