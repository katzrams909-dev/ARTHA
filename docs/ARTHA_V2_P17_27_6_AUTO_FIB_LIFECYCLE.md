# ARTHA P17.27.6 — Auto Fib Invalidation and Pre-Touch Extension

## Status
Versioned source committed to existing branch. **TradingView compilation and visual regression testing pending.** P17.27.5 remains the compile-confirmed and visually validated working baseline. This revision implements lifecycle item 1 and item 2 only; mandatory POI eligibility and production OTE entries remain future work.

## Policy
1. Origin (100%) invalidation: a **confirmed candle close** strictly beyond the 100% origin invalidates and removes the candidate from its visual archive (default). Optional `Wick` mode invalidates on a wick strictly beyond the origin. A simple exact touch of the origin is not a breach.
2. Before first OTE band touch: an opposite-side extension beyond 0% is accepted **only if the candle closes beyond the prior 0% extreme** (a confirmed breakout). Recompute 0%, 50%, 62%, 70.5%, 79%, and 100% using the same origin and the high/low of that confirmed breakout candle. The origin remains fixed. Each extension uses only data confirmed by that candle close.
3. Touch has priority over extension: if the OTE band and a new 0% close breakout both occur inside one candle, its intrabar order is unknowable; mark the band touched and freeze the previous geometry. This prevents retroactive entry-zone adjustments.
4. After first touch: keep the original Fib anchors frozen. Reaching a later extreme does not modify that candidate. A later qualifying confirmed swing can create a distinct candidate through existing pivot detection.
5. Invalidation applies whether the candidate was touched or not; it affects **visual Fib candidates only**, not existing production trades or stop-loss behavior.
6. No candidate is tested on its own confirmation candle, regardless of where its origin pivot is plotted. A new `confirmedAt` field distinguishes pivot-bar location from confirmation time. This prevents implying that a newly confirmed historic pivot was known on its original bar.
7. Apply the exact same rules to Minor, Major, and Structural Break Fib archives. Each archive keeps its existing 15-record cap. Removed candidates are never rendered in Latest or Historical.

## Implementation details
- New inputs under 14C: `100% origin invalidation` = Close (default) or Wick; `Extend 0% on confirmed breakout before OTE touch` = ON (default).
- Adds `confirmedAt` to `OTEShadowRange`. Confirmed swing archives use current confirmation bar; structure-break archives use current closed structure-break bar.
- A distinct `.copy()` is archived for a structural-break candidate so archive lifecycle mutations do not accidentally change the original shorter-lived OTE observational registry.
- `f_maintainFibArchive` loops confirmed archive records in reverse, removes invalidated elements, flags first touches, and optionally recomputes the extension geometry. It is executed in a function, on all three archives, after their new records are added and before drawing.
- Auto Fib continues to redraw only on `barstate.islast`. Production native POI logic, REV/CONT/EARLY/MISS, structural SL and TP1–TP4, trade arbitration and risk-plan management are unchanged.
- This is not an executable OTE setup. Mandatory qualified POI confluence and entries will follow in separate versions.

## Examples
- Bullish Fib: origin low = 100%, prior extreme high = 0%. A close below origin invalidates (Close mode). A close above prior high before touching OTE extends 0% to that candle's high and recomputes retracement prices. An OTE interaction first freezes levels.
- Bearish Fib: origin high = 100%, prior extreme low = 0%. A close above origin invalidates. A close below prior low before touching OTE extends 0% to that candle's low.
- Gap/crossing caveat: if the candle crosses the band in the same OHLC candle as extension, freeze without assuming the order. A wick above 0% without a breakout close does not extend in the current model.

## Validation
1. Compile P17.27.6. If CE10117 or CE10295 recurs, provide the exact error / token count. Source has not been compiled by the assistant.
2. Test NAS100, USDJPY, AUDUSD 4H with Auto Fib ON and Minor/Major/Both. Confirm older invalidated Fibs are removed from Latest and Historical display and no range changes before its confirmation.
3. On a bullish confirmed range, ensure 100% origin close breach invalidates; on a bearish confirmed range, ensure the reverse direction is correct.
4. Compare Close vs Wick invalidation on a candle with a beyond-origin wick but a close back within the range. The Close mode should retain; Wick should invalidate.
5. Test price closes beyond 0% before any band touch: Fib extends to the breakout candle extreme and retracement levels recompute; repeating multiple qualifying candles should extend until first OTE interaction.
6. Test OTE interaction and 0% breakout within the same candle: record touch and keep original Fib geometry. After touch, Fib should not migrate on later highs/lows.
7. Validate break-source and swing-source archive independence, capped object counts, and no production entry/stop/target differences from P17.27.5.
