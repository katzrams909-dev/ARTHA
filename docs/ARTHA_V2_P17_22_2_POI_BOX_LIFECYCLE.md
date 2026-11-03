# ARTHA v2 P17.22.2 — POI Box Mitigation and Fill Endpoints

## Status
Source committed; TradingView compilation and historical replay NOT verified. P17.22.1 is compile-confirmed by user.

## Scope
- Added a shared visual stop setting in G05 FVG / IFVG: First touch; 50% penetration; Full fill (default); Retirement only.
- Added Keep ended zones visible (default enabled). Native OB/BB and FVG/IFVG box right boundaries stop advancing on the first confirmed candle that meets the selected visual rule, or upon existing engine retirement.
- Source-native signal states, OB-to-BB and FVG-to-IFVG inversion, structural stops, REV/CONT/HTF FVG admission, and 1R/2R + liquidity TP3/TP4 were not intentionally modified.
- A stopped native box remains visible with END in its text; its risk eligibility is determined by the unchanged native zone-state logic, not by the presentation-only END label.
- HTF FVG preview rectangles (15m, 1H, selected custom HTF) maintain separate bounded lists of stopped origins so a stopped zone is not recreated on subsequent chart bars. They stop based on confirmed execution-chart candles after appearance; this is VISUAL policy, not a source-timeframe confirmed FVG invalidation.
- Imported HTF OB/BB candidate registry tracks a visual stop time per candidate using prior completed HTF OHLC; the underlying simplified candidate lifecycle remains distinct and unverified versus native source POIs.

## Rule definitions
- First touch: candle range overlaps the zone.
- 50% penetration: bullish zone tested down through its midpoint or bearish zone tested up through its midpoint.
- Full fill: bullish zone low reaches its lower edge, or bearish zone high reaches its upper edge. A wick counts.
- Retirement only: box ends when its established native state retires; imported HTF FVG previews cannot infer native retirement and continue under their simplified HTF FVG source state.
- A visual stop does not automatically retire an active signal POI. This prevents changes in trading behavior from an appearance-only request.

## Known caveats
- Native FVG to IFVG and OB to BB conversions reuse a single source box; if it was already visually stopped by prior mitigation, the inversion phase does not receive a fresh independent rectangle in this revision. Needs separate phase-specific drawings in a later change.
- With historical replay, completed HTF-origin boxes are back-anchored for provenance; entry decisions still use previous source bars.
- Very old boxes can be trimmed by existing zone caps. Some earlier HTF FVG preview end states track chart-bar touches rather than full source-TF mitigation.
- P17.19.1 session line visibility patch was explicitly skipped and is not merged.

## Compile / chart checks
1. Compile P17.22.2 Pine v6; report exact error line if any.
2. On GBPUSD 5m with 15m source, verify native and imported OB/BB/FVG/IFVG box endings at Full fill; check END labels and retained zones.
3. Switch to First touch and 50% penetration; check one-time stop and unchanged signal / TP / SL outcomes.
4. Replay an OB to BB and FVG to IFVG transition; flag any old box that appears to impersonate a new active phase.
5. Verify 15m/1H source-zone right boundaries only change at confirmation rules and no future data is used for trade decisions.
