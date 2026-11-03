# ARTHA v2 P17.23 — Independent Inversion-Phase Boxes

Status: committed; TradingView compilation and chart replay not yet verified. P17.22.2 is the previous user compile-confirmed and box-endpoint-validated baseline. P17.19.1 session-line patch remains skipped.

## Behavior
- On a confirmed native FVG-to-IFVG flip, end and archive the original FVG drawing at its existing visual stop (if already filled) or the inversion bar; create a new, independent IFVG box beginning at inversion confirmation, using inverse colors.
- On a confirmed native OB-to-BB flip, similarly archive the OB drawing, then start a distinct BB rectangle at the confirmation candle with BB colors.
- Original and inverted phases have separate visual stop tracking. The new inverse box's mitigation cannot be back-counted from the original birth bar; its stop policy begins after the phase starts.
- Historical phase drawings use a bounded archive of 80 boxes to protect TradingView object limits.
- Imported HTF OB/BB candidates also archive their prior OB drawing and start the BB at the confirmed lower-chart observation of the HTF inversion, with a bounded separate archive.
- Existing source POI IDs, inversion qualification, native REV/CONT and HTF FVG entry admission, structural stop logic, fixed TP1/TP2, and liquidity TP3/TP4 are not intentionally modified.

## Important limitations
- HTF OB/BB source detector remains the simplified preview candidate engine and native OB parity is not proven. It cannot create HTF OB/BB trade plans.
- Native FVG/IFVG boxes are phase-separated; the imported HTF FVG visual path is still a simplified active FVG model, not a full HTF IFVG registry.
- Earlier filled original-phase boxes can end before the inversion candle; that is correct historical mitigation behavior. The inverse phase starts at confirmation.
- Source-timeframe HTF box origin is back-anchored for historical provenance; the new BB phase starts at confirmed availability and is not tradable retrospectively.
- Inversion archives can be trimmed as configured, and Pine total max box limits still apply.

## Test
1. Compile P17.23 Pine v6. If an error occurs, share its exact line and message.
2. On GBPUSD 15m and 5m compare native FVG-to-IFVG transitions; original FVG should remain ending in its color, IFVG should start on confirmed flip with opposite color.
3. Test native OB-to-BB with the same two-phase behavior; early mitigation should not cause the BB to terminate immediately.
4. Check selected HTF candidate OB-to-BB on 5m. Confirm source OB closes and new BB candidate begins only after confirmed HTF inversion snapshot.
5. Replay to ensure no regression in native entry counts, HTF FVG entries, stops, fixed TP1 1R/TP2 2R and liquidity TP3/TP4.
