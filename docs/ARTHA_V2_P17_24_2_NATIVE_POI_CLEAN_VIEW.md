# ARTHA v2 P17.24.2 — Native POI Clean View

## Status
Committed to GitHub; TradingView compilation and runtime comparison pending. P17.24.1 has been visually reviewed on DE30EUR 15m, but this version has not yet been validated. No REV/CONT changes are intended.

## Scope
- Purely visual clean-view controls under 05 FVG/IFVG, enabled by default. Both native OB/BB and FVG/IFVG drawings respect Clean View.
- Native imbalance proximity limit default 3 ATR, order-block/breaker proximity limit 5 ATR. Far zones are hidden using transparency and empty text rather than removed from their native arrays.
- When an active native OB/BB overlaps a same-direction FVG/IFVG across at least 65% of the imbalance's price height, Clean View hides the FVG/IFVG drawing in favor of the OB/BB. This is presentation-only: both remain registered and eligible for existing REV/CONT logic. Overlap test ignores retired OB/BB records and can resolve one candle later for newly created OBs.
- Completed zones stop extending at their existing mitigation/fill endpoints. In Clean View, END drawings remain visible only for 12 chart bars after the visual stop (adjustable 0–200) and then become transparent; box end geometry is not changed.
- Historical drawings archived when FVG changes to IFVG or OB changes to BB now have their own bounded close-bar history and are deleted after the same Clean View lookback; source POI phase ID and trade-state lifecycle are untouched.
- Native zone labels use compact type + END; full provenance is still available if Clean View is disabled. Chart-timeframe POIs only; HTF POI detection remains absent.
- The REV and CONT preference inputs retain the old Nearest default. Entry qualification, reaction classification, quality scoring, risk plans, structural SL and TP1–TP4 were not modified.

## Important distinctions
- A POI hidden by Clean View remains in the source registry; its trade eligibility, mitigation state and importance are unchanged. A still-active but visually stopped zone will be hidden after the END lookback, but still active for existing trade evaluation until the original engine retires it. That is deliberate rendering/state separation and should be monitored.
- Nearest 5m/15m/1H source selection is unchanged; the script has NO HTF POI engine. Only optional HTF swing liquidity can contribute to extended target selection.
- No actual zone merging is implemented. An overlapping FVG is hidden, not merged into the OB; its metadata is not discarded.

## Validation
1. Compile P17.24.2 on the same DE30EUR 15m chart. Pine errors, if any, require exact error line/message.
2. Compare P17.24.1 to P17.24.2 at the same session and inputs; Clean View should reduce visual clutter without changing native REV/CONT or risk results.
3. Toggle Native POI Clean View OFF and verify display returns to existing native boxes/labels (except already trimmed archive drawings cannot reappear retrospectively without indicator reload).
4. Confirm a same-direction OB can visually supersede an overlapping FVG, and completed boxes disappear visually after the lookback without extending their right endpoints.
5. Validate independent IFVG and BB inversion phase boxes, their mitigation endpoints, and no regression to structural stops, TP1=1R / TP2=2R / HTF swing liquidity TP3/TP4.
6. If a distant historical zone is important visually, increase its proximity ATR setting or disable Clean View.
