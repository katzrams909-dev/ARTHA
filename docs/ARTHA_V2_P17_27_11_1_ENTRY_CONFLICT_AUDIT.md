# ARTHA P17.27.11.1 — Entry Conflict Audit and Risk Rejection Visibility

## Status
Source committed; **TradingView compilation and chart validation pending**. Last user-confirmed compiled baseline: P17.27.10. P17.27.11 source and this corrective P17.27.11.1 source have not yet been compile-confirmed by the user.

## Report
User screenshot of USDCAD, OANDA, 5-minute chart with orange arrow near a bullish FVG retest shows no production entry marker. Setup dashboard reports `RISK FILTER · STOP > 3 ATR` and `NO ACTIVE PLAN`. The dashboard message reports the latest plan-rejection condition; **without bar-by-bar debug data it cannot be conclusively tied to the orange-arrow candle**.

## Confirmed code conflicts discovered in P17.27.11
1. When a confirmed signal passes the signal engine but fails risk-plan admission, code deletes the actual signal marker from `signalLabels`. Historical rejection then looks exactly like a missing signal.
2. `f_signalDuplicate()` checked all `signalHistory` rather than accepted risk plans. Rejected signals could block subsequent attempts for the same episode/POI.
3. `f_signalAdmissionOK()` previously checked the latest signal from the **entire direction** over a 6-bar conflict window. This suppressed a distinct native POI even if the previous signal was unrelated or never became an accepted plan.
4. Rejected EARLY attempts also left `lastBullEarlySignalBar`/`lastBearEarlySignalBar` and episode trackers set, which could suppress another eligible reaction.
5. The risk gate `riskDistance<=atr*maxStopDistanceATR` (3 ATR default), stop side, and TP1/TP2 geometry are production safeguards. The patch does **not** bypass them.

## Changes
- New section 11 toggle `Show risk-rejected signal diagnostics`, ON by default.
- If rejected, keep its signal marker but replace its caption with `× REV/CONT BUY/SELL · EARLY/NORMAL/MISS\nREJECTED · STOP > 3 ATR` (or corresponding stop-side/target geometry reason) and recolor it neutral gray. **Rejected marker is never a live trade, risk plan, alert or filled position**. Toggle OFF to restore prior deletion behavior.
- Track up to 120 **accepted risk-plan setup keys** on confirmed plan creation: direction | family | episode ID | source POI engine | POI ID, bar and priority.
- `f_signalDuplicate` checks accepted setup keys, not provisional/rejected signal history, retaining the `One signal per family + episode + POI` option.
- `f_signalAdmissionOK` now compares cooldown and priority only against **accepted records of the same setup key**, not every prior same-direction candidate. Unrelated setups are no longer automatically blocked by the 6-bar same-direction cooldown. Same-bar signal arbitration remains unchanged.
- Risk-rejected EARLY attempt no longer leaves an EARLY reentry-frequency lock set on that signal bar.
- All changes stay within the signal/risk admission layer; no stop distance relaxation, TP modifications, OTE entry promotion, or global conversion to multiple same-bar orders.
- Version P17.27.11.1 on dashboard.

## What can still suppress the orange-arrow candidate
- User's specified EARLY: bullish close must be in the POI favorable half with >=25% wick/body penetration and directionally positive quality candle. A bullish close *above* POI upper edge is **not** EARLY.
- User's specified NORMAL: confirmed >=50% penetration during an armed REV/CONT retest and directional close *outside* upper edge (bull) / lower edge (bear) no more than five bars after original retest. A recent structural context alone does not arm a NORMAL setup.
- Zone retired/inverted or native POI no longer present at confirmation: normal/early POI lookup fails.
- Established REV/CONT context, primary POI gate, early quality score discount, trend filter, a prior accepted same setup, and same-bar arbitration still apply.
- Even with admitted signal, live structural stop >3 ATR or invalid target geometry still rejects the **risk plan**. This is explicitly annotated rather than misrepresented as an execution entry.
- Last-bar dashboard reports the most recent rejection and does not retrospectively identify the specific historical orange arrow.

## Testing in TradingView
1. Compile P17.27.11.1. Capture exact compiler error and line if any.
2. Enable section 11 `Show risk-rejected signal diagnostics`; revisit USDCAD 5m arrow circa 10:00 with the same chart date/history/settings.
3. If gray `REJECTED · STOP > 3 ATR` appears near the orange arrow, then the signal was admitted but stopped by risk; it is **not** a missing entry bug. Do not increase max stop ATR until reviewing the structural stop logic.
4. If no marker appears, inspect POI identity and actionability, EARLY inside-half close, NORMAL >=50% cumulative depth and outside-boundary close within 5 candles, original REV/CONT context, quality score and chart's marker-limit settings.
5. Compare another independent POI setup within 6 bars of a confirmed earlier plan: it may now proceed to risk checks even in the same direction. Same-setup duplicates remain blocked after one accepted plan.
6. Verify no rejected entry receives a risk box, target lines, a live plan ID, filled outcome, or entry alert. Verify previously accepted independent plans remain tracked.
7. Contrast P17.27.10 original, P17.27.11 classification and P17.27.11.1 diagnostic/audit on USDCAD 5m and BTCUSD 5m for legitimate signal changes.

## Pending work
- P17.27.12 should add explicit multi-plan dashboard display and same-setup EARLY->NORMAL upgrades, with strict position independence, plus label-count capping.
- P17.27.13 should improve major and confirmed higher-timeframe structural OTE swings.
- If the orange-arrow retest still lacks a label, the next iteration should introduce a bounded per-POI reason code for eligibility rejection rather than claiming it was solely a risk failure.
