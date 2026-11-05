# ARTHA P17.27.13 — Confirmed Higher-Timeframe OTE and Major Swing Filtering

## Delivery and validation status
Based on **P17.27.12.2**, the user's last TradingView **compile- and chart-confirmed** baseline. New source is versioned independently on branch `artha-v2-p17-presets`.

**Static source checks completed; TradingView compilation and chart testing of P17.27.13 are pending.** No claim of non-repainting runtime verification or compiled-token compliance is made until user validation.

## Motivation
Earlier OTE Fib studies favored minor swings and could fail to represent major market structure. The previous confirmed Major archive was already implemented, but lacked a minimum impulse-size threshold. The previous source had no separate confirmed HTF OTE swing archive.

## New controls (Section 14C)
- `Confirmed swing scale`: existing **Minor**, **Major**, **Both** retained; new **HTF**, **Major + HTF** and **All** added. Default remains **Minor** for backward compatibility; select **Major + HTF** to focus on significant confirmed swings.
- `Major minimum swing / ATR` default **2.0**; requires confirmed major pivot-to-pivot span to exceed 2 chart-timeframe ATR at confirmation.
- `OTE higher timeframe` default **240 minutes (4 hours)**; the chart timeframe **must be strictly lower** than the selected HTF to enable HTF archive construction.
- `HTF confirmed pivot bars` default **5** right and left bars. A pivot is not known until its required right-side bars finish, then one additional fully confirmed higher-timeframe candle is used as a conservative security offset.
- `HTF minimum swing / HTF ATR` default **2.5**; filters small higher-timeframe pivot pairs.

## Data and causality contract
- `f_confirmedHTFOTE()` runs in the requested higher-timeframe context via `request.security(syminfo.tickerid,oteHTFTimeframe,f_confirmedHTFOTE(),lookahead=barmerge.lookahead_on)`.
- **Every field returned by the expression is explicitly offset `[1]` inside the HTF function**: last confirmed pivot-high price/time, pivot-low price/time, 14-bar HTF ATR, post-extreme validation low/high. This is intentionally a delayed, fully completed HTF snapshot. Never remove the offsets or change to a live HTF source without a repaint audit.
- Pivots are `ta.pivothigh/ta.pivotlow(high/low,oteHTFStrength,oteHTFStrength)`; new confirmed pair events are identified by the more recent pivot's **HTF pivot timestamp**. Same-time ambiguous pivot pairs are skipped. A one-element `array<int>` retains the last seen completed pivot event, including the first event with `na` history.
- A new HTF OTE Fib is created on the **current chart confirmation bar**, not backplotted at the original historical HTF pivot. Earlier pivot prices are anchors for the Fib *values*, but no signal or drawing is retroactively added at the pivot date. The archive stores `born=confirmedAt=bar_index`.
- HTF pivots must be directionally ordered and pass the 2.5-HTF-ATR span filter. A post-extreme interval check rejects a candidate if price already breached the origin before the pair was visible.
- If the HTF 62–79% zone had already been touched during post-extreme / preconfirmation bars, `touched=true` is set from inception, preventing a past retracement from being promoted to a new A/B/C study entry after the HTF range finally confirms.
- HTF archive is bounded to 15 ranges, passed through the **existing** confirmed-bar `f_maintainFibArchive()` and its native-FVG/IFVG/OB/BB `f_otePOIIndex()` confluence gate, Wick/Close origin invalidation, OTE 0% pre-touch extension, and Aggressive/Balanced/Conservative observational study entry pipeline.

## Visualization
- Existing `f_drawFibBatch()` accepts a label prefix and reuses all original zone, line, price-level and drawing-pool logic.
- New `f_drawOTEAutoFib()` selection:
  - Minor: confirmed external structure pivots on chart timeframe.
  - Major: longer chart-timeframe pivots, with new ATR threshold.
  - Both: existing Minor + Major combination.
  - HTF: separate confirmed higher-timeframe pivot pair archive.
  - Major + HTF: both significant chart-timeframe Major and confirmed HTF.
  - All: Minor, Major and HTF together.
  - Structural Breaks in `Auto Fib anchor source` continues to override swing-scale choices, exactly as before.
- Labels have **MIN**, **MAJ** and/or **HTF** prefixes where appropriate. Shared historical drawing budget is apportioned over selected scales. All HTF drawings begin at the chart confirmation bar, deliberately prioritizing non-backpainting over historical pivot-to-pivot retroactive lines.
- The previously removed OTE dashboard remains absent. Auto Fib display is **OFF by default** as in the baseline: enable it in Section 14C to see lines and OTE zones.

## Preserved behavior
- Production EARLY (25%-inside-POI favorable-half) and NORMAL (50%-depth, directional reclaim in five bars), REV/CONT and MISS state machines.
- One winning production candidate per bar, separate independent accepted plans across bars, unique P# entry/SL/TP1–TP4 labels, open-plan dashboard, and confirmation-only EARLY→NORMAL upgrade.
- Original Causal and Local causal stop alternatives, strict 3 ATR maximum stop distance, native active POI admission, TP1/TP2 and visual liquidity TP3/TP4, independent plan outcomes and rejected-risk diagnostic labels.
- OTE A/B/C observations **do not** create production trades or modify SL/TP.
- No performance table, no top-center OTE dashboard and no obsolete OTE shadow record pool reintroduced.

## TradingView validation
1. Compile `pine/v2/ARTHA_V2_P17_27_13_Confirmed_HTF_OTE.pine`. The Pine compiler's **CE10117 100,256-token ceiling and CE10295 main-body limit** remain important. Report exact code and count if it fails. New source length is about 233,177 characters versus 229,667 for P17.27.12.2; source-character counts are **not compiled-token counts**.
2. On USDCHF 1H set Section 14C Auto Fib overlay ON, anchor source **Confirmed Swings**, scale **Major + HTF**, HTF **240**, pivot strength **5**, major minimum ATR **2.0**, HTF minimum **2.5**.
3. Check HTF ranges appear only after the previous 4-hour candle is fully closed and the pivot-right-bar confirmation is complete. No HTF study markers should appear on historical pivot candles before the confirmation bar.
4. Compare Minor vs Major vs HTF Fib sizes; on slower chart timeframes raise HTF to 1D or higher. If chart timeframe is 4H or above and HTF remains 4H, HTF scale should show **no HTF ranges**, not fabricate same-timeframe HTF.
5. Verify chart-timeframe Major ranges are significant under the 2 ATR default. Try 1.0/3.0 for controlled sensitivity tests; do not assess solely based on quantity of drawn lines.
6. Validate first OTE touches use live native POI registry and A/B/C labels remain study-only. Historical pre-confirmation HTF touches must never create late entries.
7. Compare production SL, TP1–TP4, early-to-normal upgrade and multi-plan open count against the user-validated P17.27.12.2 on USDCHF 1H, USDCAD 5m and another chart.
8. Monitor drawing object limits with All/Historical combinations; chart at maximum 500 line and 500 label objects and indicator has shared drawings.
9. Any CE10295 or CE10117 failure should prompt targeted code compacting without disabling or weakening the production risk engine.

## Next milestone
If P17.27.13 compiles and HTF chart validation passes, consider separate deterministic same-candle multi-POI arbitration as its own architectural change. Avoid coupling OTE observational promotion with it.
