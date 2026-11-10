# ARTHA P17.27.14.6 — Lean Midpoint Audit

## Reported failure
P17.27.14.5 failed TradingView compilation with CE10117: **101239 compiled tokens** vs **100256 limit** (983 over). P17.27.14.4 was the last user-confirmed compiling version.

## Optimization
- Removed the **redundant recent-entry/result-card subsystem** (the input controls, label arrays, score lookup, card text formatting, card creation/update functions and their calls). These are chart presentation features only.
- Preserved accepted-plan **historical entry markers** created at terminal outcome from P17.27.14.3, and appended realized R to those markers at that time so outcome information remains visible.
- Retained risk plan entry/stop/TP drawing while active, diagnostic setup dashboard, 50%-midpoint reclaim audit (M counter, orange audit marker), current native REV/CONT/REACTION state machine and confluence-only OTE engine.
- **No changes** to NORMAL/EARLY/MISS qualification, risk/reward calculation, 3-ATR stop rejection, OTE archives, deduplication, causal bar confirmation or alerts.
- Older source versions remain intact.

## Expected observations
- An accepted plan can show its active risk/target drawings. When it becomes terminal, a historical entry marker at the original signal bar includes trade ID, family, direction, signal source, quality, POI, TP/SL and realized R.
- For accepted historical signals without a terminal event, an active plan still uses its existing risk/target visualization. The recent-card overlay no longer duplicates these records.
- Orange `POI 50%` labels are **non-executing** observations: same confirmed bar touches a native POI at/through 50% and directionally reclaims beyond its edge. Native setups may use a multi-bar sequence; an audit marker is not evidence of acceptable structural risk.
- Production OTE remains *only a confluence filter*, not a standalone signal model.

## Validation
1. Compile `pine/v2/ARTHA_V2_P17_27_14_6_Lean_Midpoint_Audit.pine` in TradingView. The actual compiled token count is **not known**; source-size reduction is not a compiler measurement.
2. If CE10117 persists, record the new compiled-token count. Avoid deleting engine rules merely to gain token budget.
3. Confirm `Audit confirmed POI 50% reclaim (not an entry)` is enabled and `Production OTE confluence=Off` when comparing native setups.
4. On the user's 15-minute GBPUSD, USDJPY, AUDUSD and USDCAD examples, compare the M observations to user-marked orange arrows and distinguish setup detection, signal qualification and risk rejection.
5. Check TP/SL terminal historical label includes R, and dashboard M/S/R/P counters still update. Validate causal behavior with Bar Replay.

## Status
GitHub source committed; **not yet compiled or chart-validated** by user.
