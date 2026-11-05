# ARTHA P17.27.12.2 — CE10117 Token Budget Repair

## Compiler failure addressed
P17.27.12.1 failed TradingView Pine v6 compilation with **CE10117**: 101,410 compiled tokens against the 100,256 limit, i.e. **1,154 tokens in excess**. P17.27.11.5 remains the last user-confirmed compiling baseline. P17.27.12.2 is a distinct new file on `artha-v2-p17-presets`; the earlier .12 and .12.1 files were not overwritten.

## Compacting decisions
Compiled tokens are NOT equivalent to source characters; user must verify the new compiled-token count in TradingView. The following source sections were deleted, not just hidden behind input switches:

1. **Optional P16 performance attribution table and bucket cache.** Removed `f_renderPerformanceTable()`, its 7-column table, grade/source bucket arrays and their associated record/render helpers. Also removed the corresponding table and bucket input switches and two bucket recording calls at a realized terminal outcome.
   - Preserved actual `RiskPlan` lifecycle/outcomes, aggregate realized-R and REV/CONT/total win/loss counters, trade alerts, recent accepted entry/result cards and active plan displays.
   - **Capability tradeoff:** the default-off per-grade/per-source performance breakdown can no longer be opened from this monolithic indicator. It may be restored later in a separate analytics companion to avoid Pine's compiled-token ceiling.
2. **Unused structural-break shadow observation cache.** Removed `oteRanges`, its idle age/mitigation-revisit loop, and obsolete `oteMaxAge`/`oteMaxRecords` inputs. This cache was not read by entry signals, risk plans, or Auto Fib drawings; the confirmed `oteFibBreakArchive` is still populated by `f_updateOTEShadow()` with the same origin/extreme, 62–79% zone, directional break, displacement threshold and 15-range cap.
3. **Unused post-conservative OTE retest status tracking.** Removed the no-longer-displayed `retestSeen` update block and `oteRetestWindow` input. The aggressive, balanced, conservative entry events and their historical study markers/risk estimates are unchanged. Existing UDT fields are left intact to avoid unnecessary constructor churn.

Source length reduced from **234,657** to **229,667** characters (4,990 characters removed). The user-reported compiled-token excess was 1,154, but **success and margin remain unverified until TradingView compiles this new source**.

## Preserved functionality and invariants
- EARLY: 25%-penetration with bullish/bearish close within favorable half of live POI; NORMAL: 50% cumulative penetration and boundary reclaim within five bars; REV/CONT/MISS structural context and causal signal arbitration.
- P17.27.12 simultaneous **independent active risk plans across bars**, unique P# IDs on entry, SL, TP1–TP4 and recent result markers, main dashboard's newest-still-open plan and open count, EARLY→NORMAL confirmation-only upgrade without a second entry.
- Stop policy `Causal` default and `Local causal` alternative, strict 3 ATR maximum distance, live POI gate, structural SL, TP1/TP2, visual liquidity TP3/TP4, result handling, grey rejected markers, rejected-marker dedup.
- OTE **Minor/Major/Structural Break confirmed Fib archives**, historical lines/boxes, valid first touch, POI confluence and A/B/C observational labels with hypothetical SL and TP1–TP4. The previously removed top-center OTE dashboard remains absent.
- No `request.security` lookahead, no change to original REV/CONT entry families or production OTE promotion. No concurrent production entries on the same **single** bar; existing one-winner arbitration intentionally remains.

## Testing plan
1. Load `pine/v2/ARTHA_V2_P17_27_12_2_Token_Budget_Repair.pine` in TradingView Pine Editor. Check **CE10117, CE10295** or any new syntax errors. Send exact compiler code and number if failure; do not assume removed text equals tokens saved.
2. Compare to P17.27.11.5 on USDCHF 1h and USDCAD 5m: same EARLY/NORMAL/MISS signal admission, risk plan stops, targets, and grey rejected diagnostics.
3. Validate independent simultaneous plans on BTCUSD 5m or NAS100 15m with `Draw only newest active plan = OFF`. Every accepted plan must retain distinct P# and TP/SL; the main dashboard displays the number of open positions and the newest open plan even if a later plan is already stopped.
4. Confirm EARLY→NORMAL upgrade marker does not place a second risk plan or entry alert.
5. Confirm OTE A/B/C study labels, study risk, confirmed Fib overlays and structural-break range source still populate where eligible.
6. Performance table settings are intentionally absent; aggregate performance/accounting and recent result cards remain.
7. If CE10117 persists, prioritize moving other optional, non-execution visual analytics into a separate indicator rather than loosening risk admission or deleting production trade-management code.

## References
Prior version P17.27.12.1: `pine/v2/ARTHA_V2_P17_27_12_1_Dashboard_Scope_Fix.pine`.
