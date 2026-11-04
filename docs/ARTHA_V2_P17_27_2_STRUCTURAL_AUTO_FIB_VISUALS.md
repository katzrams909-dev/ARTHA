# ARTHA v2 P17.27.2 — Structural Auto Fib Visuals

## Status
Source committed to existing branch; **TradingView compilation and replay testing pending**. Based directly on P17.27.1, whose CE10295 function-extraction fix was also still awaiting user compile confirmation. Preserve all previous versions.

## Implementation
- Automatic Fibonacci uses existing P17.27 confirmed external BOS/CHoCH/MSS OTE source (with optional qualified displacement). No separate pivot or lookahead detection engine.
- On confirmation, OTE observations now also store the same origin and structural-break-candle extreme used by the existing numerical OTE calculations. Both remain frozen per observed range.
- New drawing-only function `f_drawOTEAutoFib()` uses the stored anchors and paints 0%, 50%, 62%, 70.5%, 79% and 100% levels. Price = extreme minus direction × absolute(range) × fraction. Bullish and bearish mirror each other.
- The 62% to 79% zone is a shaded box, using existing OTE band boundaries. The 70.5% reference has a stronger solid line.
- G14C controls: Show Auto Fib overlay (OFF), display mode Latest/Historical (Latest), historical range count up to 5 (default 3), right extension up to 100 bars (default 10), level label switch (ON), OTE zone shade switch (ON), adjustable bullish/cyan and bearish/purple colors.
- Uses a small bounded drawing pool: maximum 5 observed ranges × (6 lines + 6 labels + 1 shaded box). The pool is cleared and redrawn only on the chart's last bar to avoid indefinite line/box growth or stale drawings when a range expires.
- All drawing logic is isolated inside functions and calls only on `barstate.islast` to avoid reintroducing CE10295 from added top-level blocks. No new chart plot series or request.security calls.
- The model still freezes its impulse extreme on the confirming break bar; it does not follow subsequent higher highs/lower lows. Updating anchors after confirmation would require a separate causal impulse completion model.
- No new signals or entry alerts. Existing REV/CONT/EARLY/MISS, risk plan, structural SL and TP1–TP4, native OB/BB/FVG/IFVG lifecycles, midpoint LTF audit and OTE shadow count semantics remain unchanged.

## Historical mode scope
Historical mode shows up to five *currently retained* OTE observations, not the entire chart's history. The OTE engine already expires observations after `OTE observation window (chart bars)` (default 35), and caps its array at the configured maximum retained OTE observations. Expired or evicted ranges are intentionally not resurrected. The Latest mode shows the newest still-retained qualifying observation.

## Validation in TradingView
1. Compile P17.27.2 in TradingView Pine v6. If CE10295 or CE10117 recurs, report the exact message (and token count when shown). Do not infer success from GitHub commit.
2. Under 14C set Enable OTE shadow observations ON and Show Auto Fib overlay ON. Select Latest first, and optional Show OTE shadow dashboard ON to confirm range births.
3. On AUDUSD 5m, 15m and 1H confirm no Fib appears without qualifying confirmed break and that lines only appear after the source bar closes.
4. Verify six prices relative to origin and break-candle extreme, particularly 62%, 70.5%, 79% and both 0% / 100% anchors. Directionally inverted bearish levels should be correct.
5. Switch Historical mode with 3 or 5 ranges and confirm object count stays bounded; confirm draw removal at OTE observation expiration.
6. Compare normal REV/CONT/EARLY/MISS labels, POI boxes, midpoint shadow counters and structural SL/TP1–TP4 against P17.26.5.1 on the same settings/time ranges.
7. Test Auto Fib OFF and OTE shadow OFF; drawings should disappear without affecting underlying production entries.

## Notes
Adding auto-fib lines and labels increases chart object usage, but at most 30 OTE lines, 30 OTE labels and five OTE shaded boxes exist in the drawing pool. Existing TradingView object budgets still apply.