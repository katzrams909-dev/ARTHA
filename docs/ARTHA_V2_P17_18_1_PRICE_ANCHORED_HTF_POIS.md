# ARTHA v2 P17.18.1 — Price-Anchored HTF FVG Rectangles

## Status
Draft committed; not yet compiled or chart-validated by the user. P17.18 was shown in a chart screenshot but explicit compile confirmation for P17.18 was not given.

## Problem
P17.18 drew each newly confirmed 15m/1H/custom FVG box with `left=time`, i.e., the current chart-timeframe bar, even though it already retained the HTF origin timestamp. This made the rectangle begin to the right of the actual source candle and appear disconnected from price structure.

## Fix
- Change only HTF rectangle `box.new(left=...)` to use the retained `origin` (the HTF candle that formed the FVG).
- Preserve the right edge as the current confirmed chart candle and extend while the zone remains active.
- Source identity (origin and top/bottom), independent 15m/1H/custom visibility, and historical caps unchanged.
- Preserve prior-completed HTF `request.security` snapshots with `lookahead_on`, native REV/CONT entries, fixed 1R/2R primary targets and managed TP3/TP4, as implemented in P17.18.

## Causality note
A historically drawn rectangle reaches back to its origin candle as a **visual provenance annotation**. This is not when ARTHA first knew the confirmed HTF FVG; the data used for decisions is available only after the source candle closes. Do not interpret early historical box pixels as an actionable real-time signal.

## Test
Compile Pine v6. Compare 5m XAUUSD 15m/1H FVG boxes with their source HTF candles; check no floating/late-start boxes. Confirm unchanged native signal outcomes and targets on identical data and settings. Verify the same behavior on 1m charts and with custom 4H source.
