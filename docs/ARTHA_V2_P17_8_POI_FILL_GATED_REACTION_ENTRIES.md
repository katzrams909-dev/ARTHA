# ARTHA v2 P17.8 — POI Fill-Gated Reaction Entries

## Purpose

Require reaction-entry candidates to reach a configurable depth inside their POI before the reaction confirmation window starts. P17.7 remains unchanged.

## Changes

- Added `Reaction entry · Required POI fill` with options `25%`, `50%`, `75%`, `100%`, and `100% + Sweep`.
- Default is **50%**.
- Bullish POI penetration is measured from the upper edge toward the lower edge using the bar low.
- Bearish POI penetration is measured from the lower edge toward the upper edge using the bar high.
- `100% + Sweep` requires price to trade strictly beyond the far POI boundary. Existing `SWEEP_RECLAIM` close confirmation remains in place.
- The reaction candidate is only selected/armed after the chosen depth is reached; the configured confirmation window starts on that fill-trigger bar.
- P17.7's confirmation window (default 5 bars) and EARLY post-touch delay remain in place.
- NORMAL setup engine, score thresholds, signal arbitration, stop/target geometry, and outcome accounting are unchanged by this version.

## Scope clarification

The fill-depth gate applies to the adaptive reaction-entry path (MISS/EARLY). It does not change the separate NORMAL REV/CONT retest engine. Stop-loss and take-profit formulas are deliberately unchanged for this iteration.

## Follow-on review

After validating fill behavior, review wrong-direction signals and missed-entry rejection reasons. Only then proceed to the separate stop-loss/take-profit audit.

## Validation target

`pine/v2/ARTHA_V2_P17_8_POI_Fill_Gated_Reaction_Entries.pine`
