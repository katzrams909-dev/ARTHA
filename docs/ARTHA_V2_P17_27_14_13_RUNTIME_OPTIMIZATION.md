# ARTHA V2 P17.27.14.13 — Runtime Optimization, Preserve Signal Parity

## Reported error
User encountered runtime error "10110, too long to execute" after P17.27.14.12 (compact entry badges). This is a **TradingView execution-time budget** issue, distinct from CE10117 compiled-token limit (100256 compiled tokens). TradingView's currently documented limits include 500 ms per loop per bar plus dataset-wide time ceilings dependent on plan.

## Source inspection and suspected hot spots
P17.27.14.12 calculates `f_maintainFibArchive` for four active confirmed OTE archives on every historical confirmed candle. Each archive ranges to 15 entries. In each range, the code called `f_otePOIIndex` **unconditionally** and then again every candle to assign `t.poiOverlap`, which has no read path in production. `f_otePOIIndex` iterates live unified POIs. Repeating this on bars with no 62–79% price interaction produces nested scans scaling approximately with Fib-range count × POI count × bar count.

Additionally, the production MID/OTE loop searched all confirmed Fib archives through `f_oteProductionSource` for each native POI even when a native candidate already won that candle or the candle had not directionally reclaimed its POI. The risk tracking loop also updated already-closed plans repeatedly.

## Implemented in P17.27.14.13
1. `f_maintainFibArchive`: compute native POI confluence **only if the confirmed candle actually touches the relevant Fib band**. Preserve exact first-touch qualifiedTouch state, lastConfluenceBar and structural origin invalidation logic.
2. Remove obsolete per-bar assignment to `t.poiOverlap`, a data field still present in UDT but not read by any current logic. The initial value on a freshly archived Fib is retained. **Do not use this field as an up-to-date property** in future without restoring proper lifecycle management.
3. Production MID/OTE candidate selection: check same-bar native arbitration and directional reclaim before the expensive OTE archive searches. Only compute `f_oteEntryTouchBar` when a candidate Fib confluence exists. Keep midpoint touch recording when MID enabled, including even if a native candidate is already emitted on that candle; this preserves future retest state.
4. If MID is disabled, skip its unused POI-key lookup ledger while OTE continues using its separate confirmed Fib archive (a Pine input change causes a recalculation from chart history).
5. RiskPlan lifecycle: `continue` past already-terminal, outcome-recorded plans, rather than re-evaluating fields, touching deleted drawings and writing unchanged UDTs on each subsequent bar.
6. Entry logic, native source/POI identity, scoring, trend filters, OTE scale selection, 3 ATR structural stop cap, visual TP1–TP4, historical compact labels and signal alerts were **not deliberately changed**.

## Critical validation
- **P17.27.14.13 is not yet compiled or profiled in TradingView.** Source and structural logic checks do not substitute for user-reported TradingView verification.
- Compile P17.27.14.13 with the same settings where P17.27.14.12 raised 10110, matching XAUUSD 15m and other affected symbols/timeframes. If it errors, report exact error and if available execution bar/line; if CE10117, record compiled-token count.
- Compare P17.27.14.12 (if it can be loaded on shorter history) versus P17.27.14.13 with identical timeframe, symbol, history, settings: same accepted entry IDs/times/direction/source, risk rejections, SL/TP and realized R, live POI geometry and OTE confluence signals. Use Bar Replay for non-repainting checks.
- Pine Profiler on manageable bar counts can identify further CPU hotspots; profiling overhead itself may cause timeouts near the limit. Do NOT limit all trading to the most recent N bars without explicitly designing a historical warm-up and explaining effect on structure, confluence and past-performance results.
- If runtime still exceeds budget, next targeted candidates: cache repeated POI/episode lookups and reduce repeated liquidity drawing/maintenance work. Avoid shortcuts that skip bars, unconfirm pivots, trim active trade plans or disable risk gates.

## Expected performance
The largest cost reduction should come from removing O(Fib archive × POI archive) repeated scans on bars without Fib touches, but **the precise speedup cannot be estimated without TradingView Profiler**. This version favors unchanged behavior over dynamic hard caps that could silently miss trades.

## Status
Committed separately on `artha-v2-p17-presets`; P17.27.14.12 remains the last user-approved visual baseline.
