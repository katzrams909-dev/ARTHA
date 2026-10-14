# ARTHA v2 P17.9 — Inclusive POI Fill-Gated Reaction Entries

## Purpose

Make POI fill thresholds explicitly cumulative and add a 15% option for the adaptive reaction-entry path.

## Changes

- Added `15%` to `Reaction entry · Required POI fill`; options are `15%`, `25%`, `50%`, `75%`, `100%`, and `100% + Sweep`.
- Default remains **50%**.
- Thresholds are inclusive minimum depths: penetration to a deeper level satisfies all lower levels. For example, a 75% fill satisfies the 15%, 25%, 50%, and 75% thresholds; a 100% fill satisfies all five percentage thresholds.
- Fill depth uses wick extremes, not candle close:
  - Bullish POI: bar low measures penetration from the POI's upper edge.
  - Bearish POI: bar high measures penetration from the POI's lower edge.
- `100%` is reached when price touches or crosses the far POI edge.
- `100% + Sweep` remains stricter: price must trade strictly beyond the far POI boundary. Existing `SWEEP_RECLAIM` close confirmation remains in place.
- The reaction candidate is only selected/armed after the chosen threshold is reached; the configured confirmation window starts on that fill-trigger bar.
- P17.7's confirmation window (default 5 bars) and EARLY post-touch delay remain unchanged.

## Scope clarification

The fill-depth gate applies to the adaptive reaction-entry path (MISS/EARLY). It does not change the separate NORMAL REV/CONT retest engine. Stop-loss and take-profit formulas, score thresholds, arbitration, and outcome accounting are unchanged in this version.

## Follow-on review

After validating fill behavior, review wrong-direction signals and missed-entry rejection reasons. Only then proceed to the separate stop-loss/take-profit audit.

## Validation target

`pine/v2/ARTHA_V2_P17_9_POI_Fill_Gated_Reaction_Entries.pine`
