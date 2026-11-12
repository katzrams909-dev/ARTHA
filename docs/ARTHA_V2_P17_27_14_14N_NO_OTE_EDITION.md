# ARTHA P17.27.14.14N — No OTE, Mitigation/Retest Entries

## Separate full OTE-free edition
This is a **distinct** Pine v6 source, not an `Off` preset. It derives from P17.27.14.14 and shares the mitigation/retest fixes documented there.

Removed:
- OTE confluence and independent Fib entry inputs, including all Section 14C settings.
- 62–79% Fib range generation for confirmed minor/major/external breaks, confirmed HTF Fib security request, Fib archive arrays and per-candle archive/POI scans.
- Auto Fib overlay drawings and lifecycle.
- OTE admission requirement/annotation in the shared risk engine.

Kept:
- Native FVG/IFVG/OB/BB, REV, CONT, NORMAL, EARLY, MISS, `MID` at 50%, `MIT` at 15/25/75/100 (all subject to structural context/quality confirmation).
- Original-candle accepted compact labels, tooltip and terminal outcome R, independent concurrent managed plans.
- Structural stops, 3 ATR max, liquidity or fixed targets, TP1–TP4 and historical trade markers.
- Existing non-OTE confirmed higher timeframe trend/structure/target data where separately enabled; no removal of other independent features just because they use HTF.

## Performance impact
About **19,000 source characters removed**, including the nested OTE archive × native POI maintenance scans and OTE-specific confirmed HTF security request. Compiled token and runtime improvements **not yet measured**. The user previously encountered runtime 10110 on a larger build; this edition may be useful as a performance comparison but is not guaranteed to eliminate other bottlenecks.

## Validation
1. Compile `pine/v2/ARTHA_V2_P17_27_14_14N_No_OTE_Mitigation_Entries.pine` in TradingView. Record errors exactly if any.
2. Ensure no OTE settings, Fib overlay, OTE entry labels or OTE confluence filters remain.
3. Run on same symbol/timeframe/history and inputs as full P17.27.14.14 **with independent OTE OFF, production OTE confluence OFF, and Auto Fib overlay disabled**. Compare matching NORMAL/EARLY/MISS/MIT/MID signals and risk outcomes; the full version still performs OTE archive bookkeeping, the no-OTE version does not.
4. Test 15/25/50/75/100 threshold with the three confirmation modes and replay several reference setups to distinguish missed depth from rejected risk admissions.
5. Watch TradingView's total execution time. If runtime 10110 remains, profile active liquidity and per-bar POI registry scans in the no-OTE build.

## Status
GitHub committed. P17.27.14.13 remains latest user-confirmed running baseline; neither P17.27.14.14 nor P17.27.14.14N has been tested in TradingView yet.
