# ARTHA v2 P17.27.13.1 — OTE Study Removal / CE10117

## Compiler problem and status
User-reported TradingView compilation of P17.27.13 failed with **CE10117**, **100,994** compiled tokens versus the **100,256** limit (**738 tokens over**). The user elected to remove the observational OTE study engine and functionality likely to be replaced rather than weaken the production trading engine.

P17.27.13.1 derives directly from P17.27.13. It has been committed in a separate versioned file. **TradingView compilation and new compiled-token count remain pending.** P17.27.12.2 remains the last confirmed compiling, chart-validated baseline.

## Removed — intentionally
- Entire hypothetical **OTE A/B/C Aggressive, Balanced, Conservative study marker engine**: its `f_oteStudyMark` and `f_oteShowCandidateSource` and label pool.
- Hypothetical OTE SL, TP1, TP2, TP3, TP4, R-multiple calculations in `f_oteStudyRisk`, which were **not** production risk plans or trade entries.
- Study-only Section 14C inputs: entry-strength/model/markers, hypothetical risk, marker cap and reaction confirmation window.
- Study-only OTE range fields: `rejectBar`, `confirmBar`, `rejectExtreme`, `aggressiveSeen`, `confirmedSeen`, `balancedSeen`, `balancedBar`, `retestSeen`, `matchedPOIType`, `touchBar`, `hit705`.
- Study confirmation and direction-break scan within `f_maintainFibArchive`, which called the above marker engine.
- Unused local `priorTouchBar` bookkeeping in confirmed Fib construction and obsolete P16 label.

**No OTE A/B/C labels or hypothetical-study entry alerts should appear.** Any older screenshots or documentation referring to A/B/C study labels describe previous versions, not this one.

## Retained — deliberate
- **Confirmed Minor**, **Major**, **HTF** and **Structural Break** Fibonacci archives, with the HTF previous-closed-candle values from P17.27.13.
- 62%/70.5%/79% levels; range origin and zero-extension rules; 62–79% shaded zones and labels; Fib display modes Minor, Major, Both, HTF, Major + HTF, All, or Structural Breaks.
- Major minimum-swing ATR threshold; HTF selectable timeframe, HTF pivot confirmation, HTF minimum-ATR threshold and confirmed candle offsets.
- Native **FVG / IFVG / OB / BB** intersection through `f_otePOIIndex` and **first touch / POI confluence** booleans (`touched`, `qualifiedTouch`, `poiOverlap`) on confirmed Fib ranges. Historical preconfirmation HTF touches remain recorded as already touched and cannot become new first touches.
- All production **REV/CONT, EARLY/NORMAL/MISS** signal paths and their structure/POI rules. The OTE Fib engine remains observation-only, and there is **no production OTE entry promotion** in this version.
- Independent active `RiskPlan` records across bars, entry/stop/TP1–TP4 P# labels, 3-ATR maximum structural stop, Causal/Local causal choices, accepted-only duplicate/admission state, chart dashboard open count, EARLY→NORMAL upgrade-only marker, historical risk results, gray risk rejection diagnostics.
- Deleted top-center OTE status dashboard and optional P16 performance table remain absent.

## Size and token budget
- P17.27.13 source: **233,177 characters**; CE10117 at 100,994 compiled tokens.
- P17.27.13.1 source: **225,116 characters** (**8,061 source characters less** than P17.27.13).
- Actual compiled-token reduction is **unknown**: Pine's compiler inlining and optimization make source character counts an unreliable token proxy. Verify in TradingView.

## Compile and regression checklist
1. Compile `pine/v2/ARTHA_V2_P17_27_13_1_HTF_OTE_Core.pine` in TradingView and report any CE10117 or CE10295 compiler message with an exact token count where provided.
2. Test USDCHF 1H, Section 14C: enable Auto Fib, source Confirmed Swings, scale **Major + HTF**, HTF `240`; compare Minor vs Major vs HTF ranges. Ensure the selected HTF is strictly above chart timeframe.
3. Confirm HTF ranges only appear after completed HTF pivot confirmation; no retroactively created entry label on a historic pivot.
4. Confirm **no A/B/C OTE study markers** and no hypothetical SL/TP text clutter; production EARLY/NORMAL/CONT/REV entries, accepted trade plans and actual SL/TPs must remain.
5. Verify independent active plan count, P# identity labels, EARLY→NORMAL upgrade-only behavior, grey rejection reasons, and trade outcome summaries against P17.27.12.2.
6. Confirm chart's Auto Fib and drawing pool remain bounded on dense history, and option `Structural Breaks` still renders BRK Fib with original rules.

## Future direction
Revisit OTE entry execution separately as a **production-grade** native POI/Fib-confluence model with deduplicated signals, causal invalidation and dedicated risk-plan admission. Do not re-add hypothetical A/B/C dashboards merely for visual parity: their removal was explicitly requested to preserve Pine token headroom.
