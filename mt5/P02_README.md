# ARTHA MT5 P02 — Displacement-linked FVG provenance

Date: 2026-11-17  
Branch: `artha-mt5-p01`  
Source: `mt5/indicators/ARTHA_MT5_P02_Displacement_FVG.mq5`

## Status

Source committed. **MetaEditor compilation and visual tests have not yet been performed.** P01 remains unchanged and was confirmed by the user to compile with 0 errors and load on EURUSD M5 on 2026-11-16.

P02 is still a **non-trading indicator foundation**, not a port of the full ARTHA REV/CONT or entry/risk engine.

## Implemented

- Confirmed-bar-only engine retained from P01: internal/external pivots (2/5 default), preliminary BOS/CHoCH, FVG geometry, single-candle maximum overlap/mitigation, retirement on full-wick fill, native chart-object visuals.
- Three displacement qualification modes: **Body only**, **Balanced** (default), **Strict**.
- Balanced/Strict use ATR(14), body/range, body efficiency, directional close location, prior-candle body/range comparisons, prior-range close and a weighted score. Parameters match the starting defaults of the frozen Pine source where practical.
- Follow-through can contribute +5 score points. Pine's optional volume-context award is intentionally absent (its default is off).
- Episode creation and closure by direction, qualifying-event gap and maximum bars; peak score, ordinal, and recorded same-direction internal/external structure break.
- Configurable FVG provenance mode: `All` (raw P01-style), `Displacement-linked` (default), `Structural` (requires linked displacement episode and qualifying structure break).
- Up to 80 archived episodes by default, and maximum 30 recent chart FVG records.
- FVG tooltips include episode number, peak displacement score, STRUCTURAL/DISPLACEMENT/ORDINARY provenance, primary/secondary assignment and maximum mitigation percentage.
- Version property is `0.200` to satisfy MetaEditor's x.yyy warning.

## Important differences from full TradingView ARTHA

- The Pine engine uses richer episode/POI provenance and quality scoring, including configurable presets and optional volume and structure-event distinctions; P02 is a first parity approximation, not exact signal-level equivalence.
- P02 does **not** yet implement IFVG inversion, order blocks, breakers, unified POIs, liquidity registry, REV/CONT setup states, EARLY/Confirmed/MISS/MID/MIT/OTE entries, SL/TP, concurrent trade plans, dashboard or EA orders.
- A structure break opposite the current trend is marked preliminary CHoCH; MSS requires later displacement-aware structure integration.
- P02 draws FVG outlines by default to keep candles legible.
- Chart feeds may differ from TradingView's OANDA prices.

## Compile and verify

1. Download the P02 `.mq5` file from the `artha-mt5-p01` branch. Put it in `MQL5/Indicators/ARTHA/`.
2. Open it in MT5 MetaEditor and press F7. Record the exact errors/warnings. P02 is **not yet user-compiled**.
3. Remove P01 from the chart before testing P02 to avoid overlapping visual rectangles.
4. On EURUSD M5, compare:
   - `FVG creation mode = All`: should show the same raw three-candle FVG geometry as P01 (identical broker OHLC, ATR and other relevant inputs).
   - `Displacement-linked` (default): only FVGs whose direction is supported by a recent qualifying displacement episode.
   - `Structural`: a stricter subset requiring the episode to have a same-direction internal/external break.
5. Hover an FVG rectangle: check the EP/Q/provenance/mitigation tooltip.
6. Let several M5 bars close and then change timeframe away/back. Historical zone start and confirmation bars should remain consistent on unchanged OHLC history.
7. If an exceptionally large raw FVG appears, compare with `All` versus `Displacement-linked` rather than assuming all large zones are erroneous.

## Planned next milestone

After P02 compiles and the three filters behave properly: finish native FVG/IFVG lifecycle, then order blocks/breakers and unified POI admission. No trading or alerts until core parity and classification tests pass.
