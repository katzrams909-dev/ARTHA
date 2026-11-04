# ARTHA P17.27.4 — Auto Fib Anchor Visibility

## Reported issue
P17.27.3 compiled, but the user enabled **Show Auto Fib overlay** and no ARTHA-generated Fibonacci was visible on NAS100, USDJPY or AUDUSD 4H.

## Confirmed code-level cause
P17.27.3 rendered only from `oteRanges`, which removes entries after the configurable 35-bar observation window. The only creation path also required an external structure break on the same candle as qualified displacement (default) and enough ATR range. Thus Auto Fib ON did not guarantee any retained source to render. A fully empty drawing pool was possible even after valid older structural moves.

## Changes
1. P17.27.4 is a new versioned source; older versions remain untouched.
2. Added an independent, bounded visual archive (15 records each) for confirmed structural-break OTE anchors and confirmed external swing-pivot pairs. Visual Fib archive records are not deleted by the short-lived OTE observation window.
3. Added G14C **Auto Fib anchor source** selection:
   - **Confirmed Swings** (default): form a directional range between the latest *confirmed* external low and a subsequently confirmed external high (bullish) or the latest confirmed external high and a subsequently confirmed external low (bearish). Both pivots must be established, with a valid positive price span. The range is frozen when the later pivot confirms; the pivot dates themselves can be earlier than the confirmation candle.
   - **Structural Breaks**: archive the original OTE engine's frozen external pivot-to-confirmed-break-candle range, subject to the original optional displacement/ATR filters. Unlike P17.27.3, it remains visually available after shadow observation expiry.
4. Auto Fib uses the selected visual archive to draw 0%, 50%, 62%, 70.5%, 79%, 100% lines and a shaded 62–79% OTE zone in Latest or Historical mode.
5. Added optional **Show Auto Fib status when enabled** (default ON) in a small top-center 2×2 table. It reports active source, available retained ranges and READY/WAITING state. This is an operational status indicator, not a performance audit.
6. Kept bounded visual objects: up to 5 displayed ranges, six lines, six labels, one zone per range, cleared and refreshed at the last chart bar.
7. No new orders or entry signals. Existing REV/CONT, EARLY/MISS, POIs, risk plans, SL/TP and non-repainting confirmation requirements are unchanged. The old midpoint shadow audit remains removed.

## Causal caveats
- A confirmed swing pivot uses its pivot bar's price after right-side confirmation. Its line may start in the past at the pivot bar, but the corresponding Fib range does **not** become known until the newer pivot is confirmed. This is a visualization of confirmed historical swing points, not an entry signal that existed on the left-side bar.
- Confirmed Swings mode does not assert an MSS/BOS occurred; it is intended to match manual swing-to-swing Fib analysis and should not be interpreted as a structure-break trading filter.
- Historical mode shows up to five of the most recent 15 archived confirmed ranges. It does not show every historical swing.
- The chart can still show WAITING if the selected source has no confirmed pivots or qualifying structural breaks in the chart's loaded history. No synthetic levels are invented.

## Verification
1. Compile P17.27.4. Report the first exact Pine error or CE10117 token count if any. GitHub commits do not establish compilation.
2. Set **Show Auto Fib overlay = ON**, **Auto Fib anchor source = Confirmed Swings**, **Auto Fib display = Latest**, **Show Auto Fib status = ON**.
3. Verify the top-center status says **SWING — N ranges — READY** on historical AUDUSD / USDJPY / NAS100 4H data. If WAITING, check the loaded history and existing external swing settings.
4. Compare automatic and manual Fib; select the same confirmed swing extremes. Differences can arise when the manually selected major swing differs from the most recently confirmed external pivots. Also compare 62/79 versus manual 61.8/78.6.
5. Switch source to **Structural Breaks**. The indicator may show WAITING if no confirming break met displacement and ATR gates. The last qualified break no longer vanishes merely because its observation window has elapsed.
6. Test Historical mode, both bullish/bearish ranges and retained drawing counts.
7. Compare original production REV/CONT labels, native POIs and SL/TP plans against the P17.27.3 baseline on closed candles.

## Pending
TradingView compilation and visual confirmation from the user.
