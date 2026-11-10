# ARTHA V2 P17.27.14.8 — Guarded Midpoint-Reclaim Production Entries

## Evidence from user 15m screenshots
User confirms P17.27.14.7 compiles and shows 0b/1b+ audit labels on XAUUSD, NAS100, GBPUSD, USDJPY and AUDUSD.
Approximate diagnostic dashboard counts (per chart loaded history):
- XAUUSD: M233 S14 R7 P7.
- NAS100: M208 S13 R8 P5.
- GBPUSD: M223 S20 R7 P13.
- USDJPY: M210 S10 R4 P6.
- AUDUSD: M246 S31 R20 P11.
These observations are not backtest performance data, and user-marked trade arrows are manual benchmark examples rather than ARTHA signals. For these screenshots S=R+P; the primary gap is between POI reactions and emitted native signals, with a secondary structural-risk rejection problem. Some screenshots show the user-enabled trend filter as NEUTRAL/BLOCKED at the latest bar; that can veto entries when enabled.

## New (experimental, OFF by default)
Added `Enable confirmed midpoint POI entries (experimental)` to Section 14.

Production logic reuses the existing causal **50%-midpoint touch then closed-candle directional boundary reclaim** ledger, allowing up to `normalConfirmBars` from touch. On a confirmed bar, when there is no native REV/CONT signal:
- Require an active **primary** native FVG/IFVG/OB/BB source with non-null episode provenance, its birth preceding the touch and valid 50% midpoint price penetration.
- Require recent same-direction confirmed REV structural shift or CONT displacement/BOS context (within `auditContextBars`) and at least one internal/external trend direction aligned with the trade.
- Honor the user's combined trend filter if enabled, and require quality score >= existing EARLY threshold.
- Deduplicate accepted plans by the existing direction/family/episode/source POI key. One production MID candidate per candle; native NORMAL/EARLY/MISS takes precedence. Reject/retry decisions remain local to a POI, not a global direction gate.
- Source code reports `MID`, keeps the chosen original native POI identity and passes the candidate into the **existing** risk & targets engine. No bypass of stop side, structural stop, <=3 ATR risk, target geometry, OTE Require, expiry/outcome or active-plan lifecycle.
- The original causal audit labels and `M` diagnostic remain; production entries generate their own accepted/rejected trade markers. An attempt ledger keys by original POI and specific retest-touch bar so a rejected candidate does not permanently lock a later new touch.

## Limitations
- This optional model is a **closed-candle continuation/reversal reaction**, not a midpoint limit order on first touch. It cannot claim the user's exact manual arrow candle was actionable until real-time Bar Replay verifies availability of structural context and zone confirmation.
- Direction + structure context could still produce poor trades; requiring external validation of risk expectancy, false signals, and chart-history replay before using live.
- OTE remains a **production confluence condition**, not an independent standalone generator. Independent OTE requires its own explicit quality/context/stop design.
- The source is a new, unverified version. P17.27.14.7 remains the last **chart-confirmed compiling baseline**. P17.27.14.8 compiled token count is unknown and may hit CE10117 or CE10295. Source characters ≠ compiled tokens.

## TradingView validation
1. Compile `pine/v2/ARTHA_V2_P17_27_14_8_Guarded_Midpoint_Entries.pine`. If compiler exceeds token limit, report **exact count**.
2. Leave experimental MID **Off** first. Verify S/R/P and original traded levels against P17.27.14.7, on identical symbol/timeframe/preset/history and with OTE confluence Off. M should be similar on matching data.
3. Enable experimental MID; for baseline discovery keep OTE confluence Off, note whether combined trend filter displays NEUTRAL/BLOCKED and temporarily disable *only for comparison* if it blocks evaluation.
4. Compare manual arrows and native trade results; look for MID labels, accepted P# plans, gray risk rejected labels. Ensure one plan per POI setup, no new plan from same POI after accepted entry, and no retrodating/backpainting on Bar Replay.
5. Check stops are structural and <=3 ATR, and TP1–TP4 and finished historical markers are preserved. Record any false positives where MID fires on an unqualified POI or countertrend.
