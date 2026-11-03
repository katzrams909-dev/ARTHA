# ARTHA v2 P17.26.2 — Midpoint Execution Validation

## Status and baseline
GitHub source committed on artha-v2-p17-presets; TradingView compilation and playback validation are pending. Derived from P17.26.1; P17.25.3 remains the preserved stable native POI baseline.

## Goal
Correct audit trial-retention bias, report distinct 50% midpoint-limit assumptions and confirmed-close directional reclaims, classify uncertainty conservatively, and expose POI family and direction. This is an *observational* audit, not a strategy or executable order engine.

## Main changes
- Separate shadow trial registries for midpoint touches and for directional midpoint-reclaim close entries. No change to existing NORMAL / EARLY / MISS / REV / CONT logic.
- A confirmed native POI phase (FVG, IFVG, OB, BB) must exist before the touch bar. The OHLC range must cross the midpoint; a candle entirely above or below the midpoint does not count.
- At first contact, if the candle also reaches either the hypothetical stop or 1R target, classify touch-bar execution as **UNCERTAIN** and do not credit a win. This is not a substitute for true lower-timeframe event ordering.
- If the first-contact candle contains neither risk boundary, the hypothetical limit trial remains open. On later candles, stop-first and 1R-first are counted; stop and target inside the same candle are ambiguous, and unresolved positions time out at the configured horizon.
- Directional reclaim is a distinct hypothetical close-price entry after the original touch, if the midpoint trial remains unresolved and a later confirmed directional close reclaims the midpoint. It uses the POI-edge stop already attached to the midpoint trial and computes a new 1R target from reclaim close.
- Trial arrays no longer evict unresolved records when full. Instead, a new touch or reclaim is skipped and its capacity rejection recorded. Resolved midpoint records are removed after their EARLY overlap window; reclaim records are removed on outcome/timeout.
- A Pine map retains each observed source-engine/ID/phase key for the entire running script. No re-arming of the same POI phase after a resolved trial is released, and no O(n) scan of thousands of phase IDs. A configurable unique-key limit stops new auditing rather than recycling old keys.
- Audit table shows bullish and bearish statistics separately for OB, BB, FVG and IFVG, plus total midpoint/reclaim 1R rates, uncertainty, EARLY overlap, active trials, capacity skips and seen-key usage. The timeframe appears in the audit header.

## Unchanged
- Native structural POI qualification, mitigation, inversion and history protection from P17.25.3.
- REV, CONT, EARLY and MISS signal logic, conflict arbitration, stop/TP1–TP4 calculation, live labels, entry priorities and production risk plans.
- No OTE model, additional live signals, virtual orders or broker execution are introduced.

## Unresolved limitations — important
1. **No true intrabar sequencing:** The 5m/15m/1H chart OHLC does not establish whether the midpoint was filled before a stop/target within the same candle. P17.26.2 reports those bars as uncertain. A later optional lower-timeframe/bar-magnifier study would be needed to refine these cases; that has NOT been implemented.
2. **Survival selection:** The scanner uses the post-lifecycle unified POI registry on each confirmed bar. Any source phase that retired earlier on the touch candle may already have left that registry. This can omit true candidates. An independent pre-lifecycle, previous-bar confirmed POI snapshot is required before using this as a complete entry backtest.
3. **No spread / slippage / fees or executable limit proof:** The study assumes a theoretical level was resting on the prior bar and estimates risk from that bar's POI bounds and touch-bar ATR. It is not a verified filled trade.
4. **Unmatched samples:** Reclaim entries require a later directional close with surviving unresolved touch context and are NOT directly comparable to every initial midpoint touch.
5. **Capacity skipping:** The audit refuses a new trial when its active-trial cap is full; the count is exposed. A high skip count makes performance conditional on the subset observed.
6. **Side-by-side timeframe outputs:** Each chart timeframe uses its own independent registry, displacement structures and POIs. The US30 5m, US30 15m, US30 1H and NAS100 5m result sets are not identical trades.

## TradingView validation
1. Compile P17.26.2; send any precise compile message and line number.
2. For the same US30/NAS100 chart and P17.26.1 configuration, enable G14B Display midpoint shadow audit table.
3. Verify OB/BB/FVG/IFVG bullish and bearish touch counts; zero capacity skips and seen-key failures is preferred.
4. Confirm touch-candle 1R/stop overlaps go to UNCERT, not 1R. A later bar with both target and stop should also enter UNCERT.
5. Confirm no unresolved trial is evicted, and that the active trial count stays within G14B Maximum concurrent unresolved shadow trials.
6. Check the separate reclaim 1R vs stop counts and that reclaim signals are NOT added to trading labels/risk plans.
7. Compare existing REV/CONT/EARLY/MISS labels, structural stops and TP1–TP4 against P17.26.1 on the same confirmed bars.
8. If unexpected differences occur, first verify identical TradingView input presets and replay dates, then inspect source series.

## Interpretation
Prior P17.26.1 screenshots had 85–90% uncertain touch candles; their reported win percentage was based on a small and selectively resolved subset. Expect changes in both numerator and denominator. Do not interpret the table's 1R percentage as an executable win rate or as evidence of an OTE edge.