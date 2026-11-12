# ARTHA P17.27.14.14 — Mitigation / Retest Entry Repair (OTE enabled)

## Baseline and user request
Based on working-but-slow `P17.27.14.13_Runtime_Optimization.pine`. User reported that mitigation/retest percentages appear not to trigger trades, and requested a separate OTE-free edition. Previous files preserved.

## Diagnosed issues
1. `EARLY · Wick only` required wick to cross the selected threshold **and body not to**, incorrectly rejecting deep touches whose body also qualified. Fixed to `wickOK`.
2. EARLY qualification required a fresh qualifying penetration on **the confirmation candle**, even if the registered first touch occurred on an earlier candle. Fixed: register the original confirmed touch, and allow a subsequent directional favorable-half close or confirmed POI boundary reclaim within `auditConfirmBars`. It must still meet structural-context, quality, trend, duplicate and risk admission rules. EARLY detection now begins only on confirmed chart candles.
3. NORMAL REV/CONT began the confirmation deadline on **first edge touch** rather than on the first successful `normalRequiredFill` depth event. A shallow first touch could exhaust the 5-bar window before the configured 50/75% touch. Fixed: start the confirmation window when the required depth first occurs, while enforcing existing outer armed POI expiration and structure invalidation. After a qualifying depth times out without reclaim, return to ARMED instead of permanently retiring the entire episode; a later new touch may qualify. A still-valid POI and same-episode provenance remain required.
4. The previous independent `MID` path hardcoded a 50% midpoint touch and **boundary reclaim**, making 15/25/75/100 percentages irrelevant to that entry source. Added configurable independent `MIT/MID · Minimum POI mitigation` = 15%, 25%, 50%, 75%, 100%; 50% remains tagged `MID`, other levels are `MIT`.
5. Added `MIT/MID · Confirmation after mitigation` = `Favorable-half close` (new default), `Boundary reclaim` (strict historical behavior), `Directional close inside POI` (more permissive). The first requires a directionally favorable candle close in the favorable half or beyond the near edge; `Boundary reclaim` requires closing beyond the near POI boundary; the third requires directional closing on the valid side of the far edge. All close on confirmed chart bars only, can be delayed within `normalConfirmBars` after a qualifying depth touch, and pass existing context/quality/risk gates.
6. `f_poiFillReached` for MISS now requires actual candle intersection with the selected POI; prevents classifying far-away price as a mitigation touch.
7. Entry tooltip includes configured percentage and confirmation mode for MID/MIT entries. No observation labels are restored.

## Preserved
Independent OTE signal engine and confluence logic (for this version), NORMAL/REV/CONT, EARLY, MISS, MID, structural stop selection, stop side, max 3 ATR stop distance, TP1–TP4, causal POI/Fib confirmations, compact labels and closed outcome markers.

## Important semantics
- **Touch percentage does not mean an automatic fill or limit order** at that level; a confirmed candle after a touch must still satisfy the selected confirmation mode.
- Deep 75%/100% touches can invalidate or retire an FVG/OB, so a missing trade may correctly reflect lost POI identity. Source-validity is not bypassed.
- Some candidates still fail recent structural-context, quality, trend, risk distance, target geometry or duplicate admission checks. These are not defects solely because the price touched a percentage.
- The new default confirmation mode can generate **more** MIT/MID signals than the prior strict boundary reclaim; compare modes when examining parity.
- The behavior was reviewed through source inspection only. No TradingView compile/run or Bar Replay verification has yet occurred. Near-100256 compiled-token limit still applies.

## Test procedure
1. Compile `pine/v2/ARTHA_V2_P17_27_14_14_Mitigation_Retest_Entries.pine`; record exact compiler count if CE10117 or runtime error if 10110.
2. Use 15m GBPUSD, AUDUSD, USDJPY, XAUUSD and USDCAD with matched history/settings.
3. Test MIT/MID with OTE `Off` and independent OTE toggle OFF first to isolate mitigation; try 15/25/50/75/100, keep confirmation `Favorable-half close`, and compare against `Boundary reclaim`.
4. Validate EARLY Wick only vs Wick or body; Wick only must not be less permissive than wick-or-body when wick reaches threshold.
5. Confirm NORMAL depth on a later touch now starts its 5-candle window on depth, not edge touch. Check replay timing, source existence and no backdated signal.
6. Confirm entries still meet quality/structure/3 ATR risk and not every orange/manual arrow should become a trade. Record example candle timestamps where no trade appears; diagnosis should separate touch, confirmation and admission.
7. Re-enable independent OTE when comparing full edition to no-OTE edition.

## Status
GitHub committed, TradingView verification pending.
