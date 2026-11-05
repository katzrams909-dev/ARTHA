# ARTHA P17.27.11.4 — Signal State Repair

## Baseline
P17.27.11.3 **compiled in TradingView**, but user reported grey risk-rejection labels and missing or unexpectedly suppressed trade entries. P17.27.11.4 builds on that exact source; **new compilation and runtime behavior not yet confirmed**. All prior versions preserved on `artha-v2-p17-presets`.

## Verified implementation defects in P17.27.11.3
1. **Direction-wide reaction exclusion**: `alreadyCaptured` used `lastBullSignalBar` or `lastBearSignalBar` relative to the current reaction touch. That could suppress an EARLY/MISS reaction on POI B after unrelated signal on POI A, including a signal whose risk plan was subsequently rejected.
2. **EARLY repeat gate not keyed to POI**: `f_earlyReentryAllowed()` was keyed to direction/episode and reset timestamps, not the originating POI. An already emitted EARLY on POI A could block another independent POI B in the same episode.
3. **Arbitration marker mismatch**: after selecting a winner via exact episode+POI+family+source, marker retention matched only direction and family. A losing EARLY/MISS marker could survive same-bar arbitration; risk plan could bind its label instead of the winning NORMAL marker.
4. **Reaction metadata mismatch**: the selected source/POI was updated during arbitration, but `reactionPOIType` and `reactionSweepPrice` could still reflect an earlier reaction candidate from the same bar.
5. **Insufficient risk rejection detail**: grey labels only said `STOP > 3 ATR` without the actual ATR multiple or source POI ID.

## Corrections
- Removed the two direction-wide `alreadyCaptured` gates. Exact accepted-plan deduplication and admission still enforce same-POI suppression, source validity, prior structural context, quality, trend, and risk constraints.
- `f_earlyReentryAllowed(dir,family,epId,engine,poiId)` now checks **accepted risk-plan keys** for the exact source POI when same-setup EARLY repeat suppression is enabled. This makes unrelated POIs independent and prevents rejected candidates from locking another POI.
- All four NORMAL labels append `NORMAL · POI<n>` and all EARLY/MISS labels append their true source and POI ID (existing EARLY depth/type retained).
- Arbitration keeps only marker(s) matching the **exact direction, family, source, native POI ID**. Risk plan lookup applies the same source+POI test before associating the label with its plan.
- After arbitration, `reactionPOIType` is recovered from the selected native POI, and `reactionSweepPrice` is aligned to the selected direction/family and `MISS` source, avoiding a stale opposite reaction's stop context.
- Rejected labels report native POI ID and the measured `STOP <actual ATR multiple> > <configured maximum> ATR`, where applicable.
- Prior OTE Fib, OTE candidate risk study, EARLY 25%-inside-half close, NORMAL 50%-outside-boundary reclaim/5-bar window, SL/TP1–TP4, same-bar single-winner selection, 3-ATR gate, OTE-dashboard removal, and historical drawings are preserved.

## Explicit limits
- This patch does not guarantee any particular candle yields an entry: it may legitimately fail POI validity, original REV/CONT structural context, 25%-inside EARLY close, cumulative 50% NORMAL depth, 5-bar NORMAL reclaim deadline, min-score, trend, selected-signal arbitration, or the structural risk gate.
- **The grey label is a rejected candidate, never an accepted trade or filled position.**
- Existing NORMAL state machines still reset after eligibility or a 5-bar window; rejected NORMAL entries do not automatically re-arm a new NORMAL event on the same POI without a new setup. Explicit retry/upgrades should be modeled separately in P17.27.12.
- Only one winning signal per bar and one accepted plan per setup by default, while separate setup plans may coexist. Full multi-plan/multi-entry UI remains future work.
- Current `riskStopMode="Causal"` may choose a distant protected structural swing: stop >3 ATR is a genuine risk rejection under the current default, not always a signal-classification failure. Keep the 3 ATR limit unchanged until stop context is audited.

## TradingView verification
1. Compile P17.27.11.4. If CE10117 recurs, report compiled-token count; current token count unknown until TradingView runs.
2. Revisit USDCAD 5m screenshot's orange-arrow region with `Show risk-rejected signal diagnostics` enabled. See whether a **new exact source+POI** accepted or rejected marker is visible.
3. If grey rejected, note measured ATR multiple and POI ID; compare stop placement with native FVG/OB and protected structural swing.
4. Confirm two independent same-direction POIs within the previous six-bar conflict window can each reach risk admission. Ensure an accepted same setup is still duplicate-suppressed.
5. Test a bar generating NORMAL and an unrelated EARLY: verify only the exact arbitrated marker remains and any accepted risk box belongs to that POI.
6. Check EARLY still closes inside the favorable half with ≥25% penetration, NORMAL needs ≥50% cumulative and a directional boundary reclaim within five bars, and rejected labels never receive risk plans.
7. Compare against compile-confirmed P17.27.11.3 for differences. A change in suppressed independent signals is intended; a change in OTE signal/risk logic is not.
