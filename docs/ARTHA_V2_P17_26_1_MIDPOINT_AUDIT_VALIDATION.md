# ARTHA v2 P17.26.1 — Midpoint Entry Audit Validation

Status: committed to GitHub; **TradingView compile and live/replay validation pending**. Derived directly from the P17.26 midpoint shadow audit, retaining the P17.25.3 native POI engine.

## Purpose
Audit hypothetical 50% POI entry timing against a separate, confirmed-close midpoint-reclaim model, while preserving all existing REV, CONT, EARLY, MISS, independent plan, structural SL and TP1–TP4 logic. No shadow model can emit trading signals.

## P17.26.1 changes
- **Actual midpoint crossing required:** a confirmed candle must span the midline (low <= midline and high >= midline). Simply trading wholly beyond the midpoint is no longer counted as a touch.
- **Touch candle uncertainty handled conservatively:** if stop OR 1R is within the same candle that first crosses the midline, the hypothetical limit trial is flagged ambiguous. It cannot be counted as a winner, even if the target was touched. This explicitly does not establish historical intrabar fill sequencing.
- **Persistent phase-key ledger:** each source engine/source ID/phase type is recorded independently of the bounded trial-history queue, so evicting a trial cannot re-arm its old midpoint. Ledger caps at 20,000 unique keys by default (adjustable). If full, the audit refuses new trials and counts capacity rejections rather than silently introducing duplicate observations.
- **Per-type attribution:** separate touch, first 1R, stop, ambiguous and timeout tallies for OB, BB, FVG and IFVG.
- **Separate reclaim model:** after a first midpoint touch and while its shadow trial is unresolved, a later confirmed directional candle closing on the trade side of the midpoint can open a distinct observational close-price 1R reclaim trial. Its stop is inherited from the touched POI; its 1R target is calculated from the reclaim close, and its outcomes are evaluated only on subsequent bars.
- **EARLY attribution:** accepted existing EARLY signals are matched read-only to a recent touch of the exact same source phase. No signal or plan logic is modified.
- **Table:** optional G14B table (default off) reports per-type totals, overall 1R and reclaim rates, touch-bar uncertainty, timeouts, EARLY matches, history evictions and seen-key capacity rejections.

## Important biases and limitations
- **Shadow limit execution is not verified.** A bar's OHLC cannot prove order activation, spread, fill ordering, slippage or gap behavior. First-touch ambiguity prevents crediting uncertain bars but does not transform the audit into an executable backtest.
- **Survivorship bias remains:** the audit scans currently active entries in the unified POI registry *after* the source POI engine has advanced its confirmed-bar lifecycle. If a POI retires on its first midpoint touch, it may already be absent and never counted. This limitation must be addressed before using the results to approve production orders.
- **Record evictions still discard unresolved outcomes:** the 150-record bounded midpoint/reclaim histories can lose unsettled trials; unlike P17.26, they cannot cause a duplicate touch. Large eviction counts still make the win-rate incomplete. Increase Maximum shadow trial records to 300 if needed, and compare the same replay range.
- **One trial per source-phase:** source engine + ID + current FVG/IFVG/OB/BB type. One source can be tracked again in a confirmed inversion phase, but not repeatedly in the same phase. Ledger is bounded; hitting its cap blocks new trials.
- **Reclaim results and midpoint results are not paired trade P&L comparisons.** Reclaim entries need directional closes and only originate from still-unresolved midpoint trials. Their selected sample, entry price and stop distance differ.
- **No claim of outperformance:** all rates are first-touch hypothetical 1R studies, not production structural-stop TP1–TP4 executions.
- **No new entry labels, alerts, risk plans or changes to existing signal arbitration.** Current REV/CONT Nearest preference, EARLY delay and all POI mitigation/inversion rules are unchanged.

## Validation checklist
1. Compile P17.26.1 on US30USD OANDA 15m and 5m in TradingView, compare against P17.26 screenshots. Report exact compiler errors if any.
2. Under G14B turn Display midpoint shadow audit table ON, keeping shadow audit enabled and only-primary mode ON initially.
3. Check that at least one real crossing of the POI midline preceded any shadow touch. A candle entirely above/below the midline must not trigger one.
4. Check touch-bar stop/target cases counted as ambiguous and not as wins; same-bar stop and target on later candles also ambiguous.
5. Check that record evictions do not create duplicate first touches and that Seen cap rejects stays zero.
6. Compare OB/BB/FVG/IFVG counts and outcomes. Check a confirmed directional midpoint reclaim uses close entry and separate 1R results.
7. Verify all existing REV/CONT/EARLY/MISS signal labels, entry prices, structural stops and TP1–TP4 remain consistent with P17.26 for the same closed bars.
8. For statistical comparison, use identical symbol/timeframe/date/input and inspect potentially retired-on-touch zones to assess the remaining survivorship limitation.