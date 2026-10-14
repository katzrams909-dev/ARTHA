# ARTHA v2 P17.4 — Direction & Target Refinement

## Purpose

Refine signal-to-plan integrity, improve selection of causally relevant reaction POIs, and align target/stop visuals with trade direction.

## 1. Same-bar signal arbitration

Signal records now carry source and priority metadata:
- NORMAL: priority 3
- MISS: priority 2
- EARLY: priority 1

If multiple signals are emitted on one confirmed bar, the engine selects one coherent candidate for the single risk plan:
1. higher source priority;
2. higher quality score;
3. REV over CONT on a remaining family tie.

If the top-ranked candidates remain exactly tied across opposing directions, the bar is rejected as ambiguous rather than producing a potentially contradictory risk plan.

Unselected same-bar signal markers and history records are removed, counters are reconciled, and same-direction cooldown/EARLY-suppression state is rebuilt from retained signal history. Risk plan family, direction, POI and marker therefore map to the same accepted signal.

## 2. Reaction POI selection

When multiple primary POIs are touched by one candle, selection now prioritizes:
1. POI matching an active REV/CONT candidate (MISS context);
2. POI touched under recent directionally aligned REV/CONT context (EARLY context);
3. unrelated RAW POI;
4. distance to the candle close as a tie-breaker.

This addresses a concrete missed-entry path where a nearer unrelated POI could be selected first and mask a touched POI associated with an active candidate.

RAW reactions remain ineligible for execution. Existing confirmed-bar and direction-aware close confirmation remains unchanged.

## 3. TP / SL colors

- Bullish T1/T2 lines and labels use the ARTHA bullish signal color.
- Bearish T1/T2 lines and labels use the ARTHA bearish signal color.
- SL lines and labels are fixed grey.
- Entry, target, stop, risk geometry, outcome calculations and terminal drawing cleanup are unchanged.

Pine cannot read the chart's externally configured candle palette directly; these colors follow ARTHA's bullish/bearish signal colors (lime/red by default).

## Unchanged

- Market calibration presets
- REV/CONT setup state machines
- Risk/target calculations
- Trade outcome model and realized-R attribution
- Recent result cards
- Terminal line and label cleanup

## Validation target

`pine/v2/ARTHA_V2_P17_4_Direction_Target_Refinement.pine`
