# ARTHA v2 P17.5 — Visual Controls & Label Cleanup

## Purpose

Give users independent control over take-profit and stop-loss visuals while reducing redundant chart text.

## Color controls

New inputs in **12 Risk & Targets**:
- `Bullish TP line / label color` — default lime.
- `Bearish TP line / label color` — default red.
- `Stop-loss line / label color` — default grey.

T1/T2 lines and labels use the target color for the plan's direction. SL line and label use the selected stop-loss color. The user may change all three independently. These are ARTHA settings, not automatic reads of the chart's candle palette.

## Label controls

New input in **13 Trade Management**:
- `Show REV/CONT BUY/SELL in entry label` — default off.

When off, the entry detail label displays the entry price and POI/episode reference without the extra family/direction/score heading. When on, the existing family, direction, source and quality heading is included.

Existing controls remain:
- `Show ENTRY / SL / T1 / T2 labels` controls the risk-level labels.
- `Show active plan status tag` controls the separate `CONT BUY/SELL · ACTIVE` or REV equivalent; it remains off by default.
- Recent entry/result cards remain available and retain family, direction, source and outcome.

## Unchanged

- Signal direction arbitration and POI selection from P17.4.
- Presets and signal eligibility.
- Entry/SL/T1/T2 prices and realized-R calculations.
- Terminal removal of per-trade lines and labels.
- Recent result-card retention.

## Validation target

`pine/v2/ARTHA_V2_P17_5_Visual_Controls_Label_Cleanup.pine`
