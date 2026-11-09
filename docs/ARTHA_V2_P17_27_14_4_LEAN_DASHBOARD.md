# ARTHA P17.27.14.4 — Lean Dashboard + Historical Entry Markers

## Trigger
TradingView CE10117 on P17.27.14.3: compiled code **100801 tokens**, maximum **100256** (545 over).

## Changes
- Replaced 20 repetitive setup-dashboard table-cell render calls with two calls in a ten-row loop, preserving dashboard row names, values, coloring, trend/structure, plan data, and POI/ELIGIBLE + SIGNAL FLOW diagnostics (or TP3/TP4 when diagnostics disabled).
- Removed three **unreferenced** helper functions: `f_nearestPOIIndex`, `f_revStateText`, `f_contStateText`.
- Preserved the P17.27.14.3 closed-entry label behavior and previous files, all signal logic, OTE admission behavior, price history causality, 3 ATR stop gate, plan management, and risk/reward drawings.

## Compile and chart checks
1. Compile `pine/v2/ARTHA_V2_P17_27_14_4_Lean_Dashboard_Historical_Entries.pine` in TradingView. This source is **not compile-tested**.
2. Record CE10117 token count if still over; source-character reduction **does not guarantee** proportional Pine compiler token reduction.
3. Compare 15m GBPUSD, USDJPY, AUDUSD, and USDCAD with P17.27.14.2. Check diagnostic counters and accepted plan counts do not regress.
4. For accepted plans that hit a terminal outcome, a compact label appears at the original entry candle, as added in P17.27.14.3. This historical marker is limited by `maxSignalMarkers`.
5. Review known risk rejections, especially GBPUSD `STOP 3.93 > 3 ATR`, without broadening the stop filter.

## Explicit limitations
This is a **compiled-footprint refactor**, not a repair of the underlying signal qualification or an independent OTE entry generator. TradingView validation pending.
