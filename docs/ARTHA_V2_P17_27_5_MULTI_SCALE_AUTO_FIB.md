# ARTHA P17.27.5 — Multi-Scale Auto Fib Anchoring

## Status
Versioned Pine v6 source committed to `artha-v2-p17-presets`. **TradingView compilation and chart validation pending**; P17.27.4 is the user-confirmed compilation/visual baseline.

## Why
P17.27.4 successfully draws Auto Fib but selects the latest external swing, which can be much smaller than the significant dealing ranges shown by manual NAS100, USDJPY and AUDUSD 4H Fib placements. P17.27.5 allows selecting a second, independently confirmed stronger swing scale without affecting the production structure logic.

## Settings (14C)
- **Auto Fib anchor source**: `Confirmed Swings` or `Structural Breaks` (unchanged).
- **Confirmed swing scale**: `Minor` (default, preserves familiar appearance), `Major`, or `Both`. Applied when source = Confirmed Swings.
- **Major pivot confirmation bars**: default 15, min 6, max 80. The effective pivot left/right strength is `max(majorSetting, existingExternalPivotStrength + 2)` so Major is always stronger than the native external swing setting.
- Retained existing Latest/Historical display options, historical range limit 1–5, extension, labels, OTE band shade and user colors.

## Causal swing construction
- Minor: confirmed existing external high/low pivots. A new confirmed high following a previously confirmed low forms a bullish low→high range; a new confirmed low following a previously confirmed high forms a bearish high→low range. No range is armed merely because an unrelated pivot refreshed on the current bar.
- Major: `ta.pivothigh(high,effectiveMajorBars,effectiveMajorBars)` and its pivot-low counterpart are evaluated on every bar. Range creation waits until the pivot is confirmed after the requisite right bars. High/low prices and pivot bars are retained in an array-backed `OTEPivotState` object so state can be managed within a function.
- All Fib levels are derived from immutable endpoint prices as of confirmation; the fact a line begins at a historical pivot bar is a visualization of when the swing occurred, **not** a claim that the corresponding major pivot was known at that earlier bar.
- The major swing selection uses stronger pivots, not an ATR trend/regime classifier or manual swing selection. It will not necessarily identify exactly the same major impulse chosen by a trader.
- Structural Breaks source retains P17.27.4's original confirmed structure-break and optional displacement eligibility, with its archive surviving the 35-bar OTE observation expiry.

## Rendering and limits
- Minor: draw up to 1 latest or 1–5 historical minor ranges.
- Major: draw up to 1 latest or 1–5 historical major ranges.
- Both: draw one latest of each, or divide historical count between major and minor with a maximum of 5 historical range drawings (a selection of 1 intentionally draws one of each so both scales remain visible). Larger-scale 70.5% lines are thicker, while minor levels/zone are faded; labels use MAJ/MIN prefixes in Both mode.
- Each archive capped at 15 records. Active drawing pool is cleared/redrawn on last chart bar only, at most 6 level lines + 6 labels + 1 OTE zone per selected range.
- The top-center Fib status table now reflects the selected scale and includes major/minor counts when Both is selected.

## Preserved
No changes to production native OB/BB/FVG/IFVG lifecycles, REV/CONT/EARLY/MISS arbitration, structural stop, TP1–TP4, risk-plan management or HTF behavior. The midpoint shadow diagnostics remain removed. No VWAP and no new automated OTE entry signals.

## Validation
1. Compile **P17.27.5** in TradingView Pine v6; report first exact error or CE10117 compiled token total. Static inspection is not compilation.
2. Test NAS100USD 15m, NAS100USD 4H, USDJPY 4H and AUDUSD 4H against manually placed Fib levels.
3. In 14C set Auto Fib overlay ON, anchor source Confirmed Swings, scale Minor, Latest. Confirm identical display to P17.27.4 except improved duplicate-swing handling.
4. Switch to Major and verify broader ranges anchor to **confirmed** pivot extremes and remain fixed afterward. If no major pivot has yet confirmed on loaded history, status should show WAITING.
5. Switch to Both: one major and one minor latest range, distinguishable through stronger major 70.5% line and dimmer minor drawings; historical mode remains bounded.
6. Test source Structural Breaks to verify scale selector does not modify break model.
7. Verify production signals, stops, targets, native FVG/BB/OB drawings and chart performance remain consistent with P17.27.4 on closed bars.

## Compiler considerations
P17.27.5 adds an archive and concise helper functions; source and logic were reviewed but compiled tokens cannot be counted offline. If CE10117 or CE10295 appears, retain P17.27.4 as confirmed working baseline and optimize **only Auto Fib additions**.
