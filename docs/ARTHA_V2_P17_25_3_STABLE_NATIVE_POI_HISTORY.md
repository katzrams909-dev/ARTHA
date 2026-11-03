# ARTHA v2 P17.25.3 — Stable Native POI History

Status: committed, pending TradingView compilation and chart validation. Built directly from P17.25.2 OB Visibility Audit, not P17.25.1.

## Issue reported
Two consecutive GBPUSD 15-minute screenshots showed a historical FVG drawing missing in one view and visible in another. Prior versions showed OB drawings behaving similarly. This does not, on its own, prove trade signals repaint; inspection found dynamic drawing conditions capable of historical hide/reappear behavior.

## Causes in prior source
- FVG/IFVG drawing visibility was recalculated every bar from current close, ATR, and overlap with a same-direction active OB. These changing variables could hide or reveal a previously confirmed FVG.
- Clean View hid END boxes older than 12 bars and deleted archived FVG phase boxes, even though P17.25.2 preserved OB archives.
- Mitigation, visual stop and native POI inversion transitions were evaluated intrabar. These could temporarily affect drawings on an open candle then roll back on TradingView's next execution.

## P17.25.3 changes
- G05 adds Audit: keep confirmed FVG / IFVG visible, ON by default. It bypasses proximity, overlap and END-age filters for FVG/IFVG drawings and protects archived FVG phase boxes within the bounded 80-box archive cap.
- Native POI Clean View defaults OFF. Existing audit controls for OB/BB remain ON.
- POI lifecycle state transitions and visual-stop checks for FVG/IFVG and OB/BB are gated on barstate.isconfirmed; source FVG and structural OB creation were already close-confirmed.
- Original FVG and OB qualification, native REV/CONT selection logic, quality scoring, structural stop and TP1–TP4 remain unchanged.

## Limits
- No guarantee of infinite historical drawings: tracked imbalance cap is 30, tracked OB/BB cap 24, inversion history cap 80. Reaching a cap can delete old drawings and source records.
- Display will be denser than the Clean View. This is deliberate for auditing historical evidence.
- Actual source-series repaint must still be checked by chart reload/replay, not inferred from two screenshots.

## Validation
1. Compile P17.25.3 on GBPUSD OANDA 15m; report exact error line if any.
2. Turn Native POI Clean View OFF, both FVG and OB audit-history controls ON, and Keep ended zones visible ON.
3. Watch the historical FVG at NYH and OB at PDH; neither should toggle visibility due to current price/ATR or overlap filters.
4. Replay inversions across confirmed candles. Check separate source phase boxes and stop endpoints.
5. Compare REV/CONT signals, SL, TP1–TP4 against P17.25.2, taking care to compare confirmed bars.
6. If history still disappears, first check registry/archive pressure, then source-series confirmation or historical/realtime disparity.