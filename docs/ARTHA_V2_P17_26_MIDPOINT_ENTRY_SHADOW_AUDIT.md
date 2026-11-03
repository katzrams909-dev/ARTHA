# ARTHA v2 P17.26 — Midpoint Entry Shadow Audit

## Status
Committed to GitHub, TradingView compilation and runtime validation pending. This version derives from the user's P17.25.3 working baseline. P17.25.1 delayed OB implementation is not included.

## Purpose and current behavior
The established EARLY/MISS reaction path already defaults to a 50% wick penetration trigger, but generates a signal after confirmed contextual/reaction conditions with entry at the signal candle's close. P17.26 does NOT change that path. It measures whether a separately priced 50% POI limit-style entry might provide useful timing, before any order-generation changes.

## New independent G14B controls
- Enable midpoint shadow audit (no signals): ON.
- Audit only primary displacement-linked POIs: ON. A source POI must be primary and episode linked.
- Directional midpoint reclaim window: 5 confirmed bars after touch.
- Hypothetical 1R evaluation horizon: 25 bars after touch.
- Hypothetical stop: beyond POI edge by 0.10 ATR from the touch bar, floored to one tick.
- Maximum retained shadow trial records: 150; existing histories bounded.
- Display midpoint shadow audit table: OFF by default to prevent chart congestion.

## Mechanics
- Independently observes eligible active native FVG, IFVG, OB and BB records in the unified POI registry. Uses stable source engine, source ID and current phase type as the de-duplication key. A single source phase is normally audited once while it remains in bounded history.
- Midpoint price = (POI.top + POI.bottom) / 2. Touch: bullish low <= midpoint; bearish high >= midpoint.
- Only considers a touch after the POI's current source phase was born/confirmed; the bar that creates a FVG/OB or flips it to IFVG/BB is excluded.
- Assumes a hypothetical midpoint level entry, with POI-edge stop plus ATR buffer and 1R target. This is a *shadow assumption*, not a placed order or a verified intrabar fill.
- Outcome starts on the NEXT confirmed bar after midpoint touch. First stop = loss; first 1R = win; both in the same candle = AMBIGUOUS (excluded from resolved win-rate); otherwise TIMEOUT after the horizon. No claims are made about event ordering inside the touch candle.
- Tracks a separate directional close reclaim if, within the reclaim window before outcome resolution, candle closes across the midpoint in trade direction and candle body is directional. It is a diagnostic, NOT a new trade.
- The exact accepted existing EARLY reaction source is checked against a midpoint trial touched in the previous reclaim-window bars and counted as Existing EARLY matched. Normal REV/CONT, MISS, and unmatched EARLY are untouched.

## Caveats and statistics
- This 1R audit is NOT equivalent to the production structural stop engine, spread/slippage/commissions, actual limits, or TP1–TP4. Sample selection differs from EARLY entries; raw win-rate comparison is not a causal performance comparison.
- First-touch bar stop/target order is intrinsically unknown from 15-minute OHLC. The study begins outcome assessment only on later candles; results are optimistic or pessimistic depending on what happened within the touch bar. Avoid interpreting as executable P&L.
- If stop and target both hit on a later candle without lower-timeframe sequencing, outcome is marked ambiguous; do not count it as a win.
- A record evicted due to the bounded 150-trial cap can eventually be re-observed; the table reports record evictions. Increase the cap or restrict the test window for cleaner estimates.
- This model only observes existing active POIs in the registry, not already retired or older trimmed POIs. The existing POI limits and lifecycle remain unchanged.
- A reclaim may occur after its initial touch and is counted separately from the virtual limit outcome. Touch and reclaim events must not be treated as equivalent entry prices.
- The setting for Native POI Clean View, OB/FVG audit-history controls, REV/CONT Nearest selection, existing risk plans, and HTF POI removal remain as in P17.25.3.

## Acceptance test
1. Compile P17.26 on TradingView Pine v6; provide precise errors if compilation fails.
2. Use GBPUSD OANDA 15m with the same P17.25.3 inputs; enable Display midpoint shadow audit table under G14B.
3. Check that the existing entry labels, risk plans, structural stops, and TP1–TP4 match P17.25.3 on confirmed bars.
4. Check 50% touches, directional reclaims, 1R-before-stop and stop-before-1R statistics. Ambiguous and timeout cases must not inflate resolved wins.
5. Verify a newly created FVG or flipped BB/IFVG never gets a virtual limit entry on its creation/flip candle.
6. Inspect Existing EARLY matched to determine overlap, but do not infer execution superiority until paired-case tests with lower timeframe fill assumptions.
7. After the baseline compiles and observations are sensible, use results to design a proper OTE model with confirmed impulse anchors and independent model attribution.