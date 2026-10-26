# ARTHA v2 P17.14 — Completed Session High/Low Liquidity

## Status
Draft committed on `artha-v2-p17-presets`. **Not yet compiled or chart-tested in TradingView.** P17.13.1 is the latest user-confirmed compiled version.

## Implementation
- Adds three configurable sessions with on/off toggles: Asian `ASH/ASL`, London `LDH/LDL`, New York `NYH/NYL`.
- Default session definitions in `America/New_York` time: Asia 20:00–00:00, London 02:00–05:00, New York 08:30–12:00. These are configurable windows for the liquidity model, not claims about official exchange hours. IANA timezone handles DST transitions for the configured zone.
- Session price extremes update on **confirmed chart bars** only and are registered **after the session ends**. No unfinished-session high/low enters the eligible pool.
- Levels use existing liquidity registry `f_registerReference`, `f_supersedeSource` and the existing sweep/resolution and visibility lifecycle. Completed session levels default to Tier 2, adjustable 1–4.
- Existing TP1/TP2 liquidity candidate selection and visual-only TP3/TP4 are automatically able to select eligible session levels when direction, active state, distance, separation, and tier filters are satisfied.
- Existing TP1/TP2 execution accounting, stop placement, entry labeling, and persistent risk-plan behavior unchanged.

## Chart validation
1. Pine v6 compile.
2. Confirm ASH/ASL, LDH/LDL, NYH/NYL only appear after session close, using suitable intraday chart history.
3. Confirm no retrospective changes of registered prices; check session windows around US daylight-saving transitions.
4. Verify a session level that has been swept/resolved is not picked as a new TP3/TP4.
5. Confirm correct selection on NAS100USD and US30USD in both directions, when eligible session liquidity lies beyond TP2.
6. Confirm visuals do not exceed object limits on long intraday history.
7. Confirm existing user-validated entry labels, directional reward/risk colors, and plan persistence remain intact.

## Design notes
- These are **completed-session** levels rather than developing live-session bands.
- The session definitions are configurable; market symbols may have different underlying exchange schedules and data availability.
- No eligible level beyond TP2 continues to mean no synthetic visual TP3/TP4.
- Source code is `pine/v2/ARTHA_V2_P17_14_Session_High_Low_Liquidity.pine`.
