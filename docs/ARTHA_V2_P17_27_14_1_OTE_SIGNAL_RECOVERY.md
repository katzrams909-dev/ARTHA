# ARTHA P17.27.14.1 — Missing-Signals OTE Admission Repair

## Reported symptom
User confirms P17.27.14 compiles but reports **no signals generated**. P17.27.13.1 is last chart-confirmed baseline; P17.27.14 only has compilation confirmation.

## Confirmed source diagnosis
P17.27.14 does **not** generate standalone OTE entry candidates. It applies an optional gate to the already produced native REV/CONT EARLY/NORMAL/MISS candidate at the RiskPlan admission stage. With `Production OTE confluence=Require`, the gate required a Fib's *very first post-confirmation touch* to be within five chart candles, and that first touch to have registered a live native POI. A valid later retest could never requalify, leading to severe suppression and plausibly zero accepted trade plans.

When `Production OTE confluence=Off`, the new gate is logically bypassed (`oteAccepted=true`). If Off also shows no signals, the P17.27.14 OTE gate does **not** explain that behavior. Check underlying candidate formation, Risk/ATR rejections, signal marker visibility, chart/timeframe and input settings before claiming resolution.

## Implementation
- A new `lastConfluenceBar` field is added to archived Minor/Major/HTF/BRK Fib records. It updates on **each** bar after Fib confirmation where candle price touches its 62–79% zone and the existing `f_otePOIIndex` finds a live, same-direction native POI.
- `f_oteProductionHasPOI` now requires recent `lastConfluenceBar` within the specified window and an overlap between that still-valid confirmed Fib band and the native POI **actually selected by the current execution signal**. The first archive POI's arbitrary identifier is intentionally **not** used to lock out another selected same-direction overlapping POI.
- The setting is relabeled `Production OTE recent confluence window (bars)`; default still 5, max 20. The first-touch record `firstTouchBar` remains for historical integrity.
- Off, Annotate and Require semantics remain unchanged:
  - **Off:** no new OTE veto; same baseline REV/CONT admission checks.
  - **Annotate:** existing accepted entries retain their prior eligibility and receive OTE attribution only if recent confluence exists.
  - **Require:** native candidate must also have recent live POI/confirmed Fib overlap; never promotes a standalone OTE trade.
- All original stop-side, maximum 3-ATR risk, target geometry, accepted-only dedup, TP1–TP4, and multi-entry plan management are unchanged. Rejection reasons include `OTE NO CONFLUENCE` when appropriate.
- Never treat an OTE Fib that is only visible retrospectively as a newly created historic trade. HTF range is still born on its *confirmation* chart bar, and no developing HTF security fields are used.

## Remaining bounds
The retest ledger stores a **bar**, not an exact per-POI identity. Confluence is established if a live native same-direction POI was present at the zone's recent retest and the selected native POI overlaps that Fib band at admission. An exact historical per-POI retest ledger would be more discriminating and is deferred for token-cost reasons.

This is an admission-filter correction, **not** a new OTE entry generator. A valid Fib+POI without a native REV/CONT EARLY/NORMAL/MISS candidate still produces no production plan.

## Compile and chart validation
1. Compile `pine/v2/ARTHA_V2_P17_27_14_1_OTE_Signal_Recovery.pine`. Record CE10117 count or CE10295 if present. The last **compiled** P17.27.14, but this patch remains compile-unverified.
2. For a direct baseline comparison, set `Production OTE confluence=Off` on the same symbol/timeframe/settings. Check visible native entry labels, green trade result cards and grey `REJECTED` risk labels. With Off, any missing native candidates cannot be blamed on the OTE admission gate.
3. Set `Annotate`. Accepted entries should remain comparable to Off; some may append `OTE MAJ`, `OTE HTF`, `OTE MIN` or `OTE BRK`.
4. Set `Require`. Some candidate trades without recent confluence will correctly be rejected as `OTE NO CONFLUENCE`. At least qualified later retests are now eligible, instead of requiring the first historic touch.
5. Vary `Production OTE scale`: `All` is best for diagnosing sparse `Major + HTF` confluence; `Major + HTF` is deliberately more selective. Also compare a 5-bar and 15-bar confluence window.
6. Compare P17.27.13.1 against P17.27.14.1 with `Off` to isolate unintended regression. If Off has zero and baseline has signals, save a screenshot including Section 14C settings and the setup dashboard.
7. Check no accepted trade gets created when original structural stop >3 ATR or the underlying native signal never fired; concurrent P# plans and EARLY->NORMAL no-duplicate logic must remain intact.

## Versions
All prior files are preserved on branch `artha-v2-p17-presets`. This source is a **new, uncompiled P17.27.14.1**; no previous version overwritten.
