# ARTHA P17.26.5.1 — Compact Execution Reliability (CE10117 Fix)

## Compile constraint
TradingView user reported compiled tokens = 104862, maximum = 100256 for P17.26.5 (CE10117). P17.26.5.1 was rebuilt from P17.26.4, which the user had confirmed compiled and visually tested, rather than continuing to expand the oversized P17.26.5 version.

## Implemented
- Preserved P17.26.4 native POI engine, confirmed-close previous-bar POI snapshot, frozen midpoint risk levels, request.security_lower_tf sequencing, midpoint and reclaim shadow trials, per-POI-family and direction counters, shadow de-duplication, and original production entry/risk logic.
- Added separate audit evidence categories for LTF-derived first-target / first-stop / uncertain events, versus chart-OHLC fallback events. Each midpoint trial is counted exactly once upon its terminal outcome, whether that occurred on the initial touch bar or later.
- Replaced the multi-page audit dashboard with a 4-column, 12-row rendering. Shows OB/BB/FVG/IFVG summary totals, LTF and fallback outcomes with their separate resolved-only win percentages, LTF coverage %, LOW indicator under 80%, inspected/unavailable counts, EARLY overlap, prior-phase disappearance total, active-trial count and capacity skips.
- Compacted version has 222500 source characters, about 2500 fewer than the P17.26.4 compiled baseline, and considerably fewer than the P17.26.5 CE10117 failure. Source character count is NOT identical to Pine compiled-token count, so compilation must still be checked in TradingView.

## Deliberately deferred
- The per-source matched midpoint-versus-reclaim outcome matrix and separate inversion / retirement / other-removal breakdown introduced in the P17.26.5 over-limit source are not carried into the compact fix. Existing separate reclaim shadow outcomes remain in their arrays but are not separately displayed in the compact table. These features can be restored in later optimized iterations after verifying token headroom.
- No OTE logic or live midpoint entry signals.

## Preserved invariants
REV/CONT/EARLY/MISS signals, trade-plan admission, structural SL/TP1–TP4, POI qualification/mitigation, inversion boxes, non-repainting confirmed close rules and HTF POI removal remain as in the compiled P17.26.4 baseline.

## Validation procedure
1. Compile P17.26.5.1 in TradingView. If CE10117 still appears, report compiled token total. If a different compiler error appears, report exact line and message.
2. Compare AUDUSD 5m / 15m / 1H on the same historical segments as P17.26.4 and enable the 14B audit table.
3. Confirm LTF coverage, LTF W/L/uncertain and OHLC fallback W/L/uncertain. Sum of those outcome groups should equal registered midpoint terminal W/L/uncertain classifications, excluding currently open or timeouts.
4. Confirm all production signal labels, POIs and structural SL/TP outputs match P17.26.4 on closed bars; audit must not change them.
5. If compilation passes, treat P17.26.5.1 as an evidence-quality checkpoint and address matched-case and lifecycle decomposition only in token-efficient isolated revisions.