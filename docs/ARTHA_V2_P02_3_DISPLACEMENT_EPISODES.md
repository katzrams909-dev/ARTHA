# ARTHA v2 P02.3 — Displacement Episode Aggregation

## Purpose

P02.2 successfully identifies high-quality displacement bars, but a single institutional impulse can contain several qualifying bars. P02.3 preserves each bar event for diagnostics while aggregating related events into one directional episode for downstream engines.

## Episode rules

An episode starts on a qualified DSP bar.

A later qualified DSP bar joins the active episode when:

- it has the same direction;
- the gap since the previous DSP does not exceed the configured allowance;
- the episode has not exceeded its maximum duration.

Default settings:

- allowed gap: 1 bar
- maximum duration: 8 bars

An episode closes when:

- an opposite-direction DSP appears;
- the allowed gap is exceeded;
- maximum duration is reached.

The stored episode end bar is the last qualifying DSP bar, not the later bar that confirms the episode is over.

## Episode payload

Each completed episode stores:

- ID
- direction
- start bar
- last DSP/end bar
- peak-score bar
- peak displacement score
- number of qualifying DSP bars
- episode high
- episode low
- summed body/ATR expansion
- whether structure broke during the episode
- structure scope
- structure kind

## Downstream contract

Future FVG/IFVG and OB/BB engines should reference an episode ID where possible rather than treating every qualifying displacement candle as an unrelated impulse.

Individual DSP bars remain available for:

- MSS classification
- diagnostics
- detailed provenance

Episode aggregation does not alter P02.2 qualification thresholds.

## Non-repainting behavior

Episodes are built only from confirmed DSP events. Finalization may occur several confirmed bars after the last DSP bar, but the historical start/end/peak bars do not move after completion.
