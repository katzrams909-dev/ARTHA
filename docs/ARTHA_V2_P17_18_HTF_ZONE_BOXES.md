# ARTHA v2 P17.18 — Confirmed HTF FVG rectangles

## Status
Committed draft, **not yet compiled or chart tested in TradingView**. P17.17 was user-confirmed compiling; P17.18 retains its signal/target logic.

## Changes
- Replace four stepped HTF FVG boundary plots with source-timeframe-labelled translucent rectangle boxes.
- Independently display confirmed 15-minute and 1-hour FVG zones (toggles in `03A Multi-Timeframe Context`). When the selected POI source timeframe is different from 15m/1H, a third independently toggled custom-source FVG visualization appears.
- Keep the existing selected `POI source timeframe` as the one used for the HTF-FVG alignment check; drawing 15m/1H boxes does **not** combine their signals or add a separate independent entry path.
- Maintain one active FVG state per visual timeframe (not a full FVG/IFVG/OB/BB registry). When replaced or invalidated, the previous rectangle stops extending and remains a historical bounded zone, subject to a per-timeframe history cap.
- Draw a zone only starting at the lower chart's **first confirmed accessible source snapshot** (no retroactive left edge at the source candle), despite retaining the source-origin timestamp as an identity key.
- The HTF signal/context and targets continue to use prior completed source timeframe data with lookahead-on. Visualization switches never alter strategy signals, risk, or exit accounting.
- `Maximum historical zones per timeframe` defaults to 12, with customizable bull/bear colors and fill transparency. Native chart-timeframe POI display settings are unchanged.

## Validation
1. Compile Pine v6 and replay full historical bars, including previously reported bar 5805 dynamic history boundary.
2. On 5m XAUUSD chart, verify independent 15m and 1H FVG zones have rectangles rather than stepped boundary lines.
3. Toggle 15m zones off and confirm 1H remains; reverse. If POI timeframe is 4H, confirm custom-source toggle controls the 4H zone only.
4. Confirm a newly identified HTF zone never appears to the left of the first lower-timeframe candle on which the **confirmed** HTF data was available.
5. Compare native entries/SL/TP1/TP2 and managed TP3/TP4 with P17.17 under otherwise identical settings. Rendering changes should not modify trade selection.
6. Verify no excess box accumulation, especially with all three visual sources enabled and native FVGs/OBs visible.

## Out of scope
- Full independent multi-timeframe POI registry or HTF OB/BB rendering; these require a subsequent structural engine, not merely a plotting change.
