# ARTHA P17.27.11.2 — CE10117 Compiled-Token Compact

## Status
Source committed to `artha-v2-p17-presets`. TradingView compilation remains **unconfirmed**.

## Report
P17.27.11.1 failed TradingView Pine v6 compilation: **CE10117 — 100647 compiled tokens, limit 100256**, excess **391 tokens**. Its predecessor P17.27.10 is the last user-confirmed compile-successful version.

## Targeted compacting
- Replace the **four duplicated normal REV/CONT setup quality-scoring blocks** (bull REV, bear REV, bull CONT, bear CONT) with one shared function `f_normalSetupQuality` defined ahead of the first consumer.
- Function receives the same episode ID, family, shift scope/kind, native unified POI index and context points. It computes the **identical** displacement, structure, POI, mitigation and context scores.
- Returns `[total,breakdown]` retaining the exact prior total score cap (100) and `D... S... P... M... C...` breakdown format. Each consumer still computes grade via `f_qualityGrade`.
- No planned modifications to the 25%-inside-POI EARLY / 50%-outside-POI NORMAL classification, MISS, 5-bar confirmation window, risk filtering, accepted-plan scoped signal conflict checks, risk-rejected signal diagnostics, OTE or trade management.
- Compacted source length reduced by about 923 characters, **but source character count is not the Pine compiled-token count**. Actual CE10117 status requires a fresh TradingView compile.

## Test
1. Compile `pine/v2/ARTHA_V2_P17_27_11_2_Token_Compact.pine`; report success or the exact error line, code and compiled-token number. No success claim until TradingView confirms.
2. Inspect the USDCAD 5m screenshot's orange-arrow vicinity with `Show risk-rejected signal diagnostics` enabled. Gray markers are historical **rejected** plans, not active trades.
3. If the label still does not appear, investigate native POI/source identity, 25%-inside EARLY conditions, 50%-outside NORMAL conditions, context/score and signal arbitration. The last dashboard rejection is not necessarily tied to the orange arrow.
4. Check that normal REV/CONT score and breakdown text match P17.27.11.1 logic exactly; accepted-plan admission and risk filtering must remain unchanged.

## Preservation
P17.27.11.1 over-limit code and prior compile-confirmed P17.27.10 remain intact on the GitHub branch.
