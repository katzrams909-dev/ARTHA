# ARTHA v2 P17.26.3 — Pre-Lifecycle POI Snapshot

## Status
GitHub source committed, static reference checks passed; TradingView compilation and runtime results not yet verified. Derived directly from P17.26.2 with the prior stable P17.25.3 native POI engine.

## Reason for this change
P17.26.2 scanned the unified POI registry AFTER the current bar's confirmed mitigation, retirement and inversion logic. If the first midpoint retest also retired or inverted its original FVG/IFVG/OB/BB phase, the old phase could be absent and its would-be midpoint touch could be omitted. This is a selection/survivorship bias, not evidence that the actual broker would have filled an order.

## Implemented source-level changes
- Add an independent, object-free ShadowPOISnapshot of source key, POI type, direction, top/bottom and phaseStartBar. Build it at each confirmed candle's end from currently eligible active unified POIs.
- On the NEXT confirmed candle, evaluate midpoint interactions against the stored previous-close snapshot BEFORE replacing it with the newly confirmed source state. No new source-zone or inverted phase can be touched on the candle on which it is first registered.
- A previous-bar OB that becomes BB this bar can still be observed as an OB-phase midpoint interaction; its successor BB may be snapshotted for the next bar independently. The same applies to FVG->IFVG and complete source retirement.
- Add Retired on touch count: how many newly touched snapshot source phases were missing from the current post-lifecycle unified registry (including inversions, retirements and registry trims). A snapshot missing from the registry does not necessarily mean it retired due to midpoint touch alone; interpret as a lifecycle disappearance count.
- Retain independent bullish/bearish POI family statistics, touch-candle uncertainty, separate reclaim-entry shadow model, persistent phase ID ledger, capped ACTIVE trial lists and existing EARLY overlap counts.
- All changes are internal to shadow audit state. No changes to REV, CONT, EARLY, MISS, risk plan creation, structural stops, targets, POI eligibility, native mitigation rules or drawing behavior.

## Risk/limitation notes
- Snapshot eligibility is based on a previously confirmed POI and not a retrospectively selected current-bar POI, improving causal entry eligibility.
- The shadow study still assumes a hypothetical resting midpoint limit and cannot determine actual fill sequencing within OHLC. Touch candles that also reach stop or target stay UNCERTAIN.
- Stop buffers still use ATR available at touch-bar close, not locked at prior-bar order-arming time. This is a remaining methodological weakness for executable limit comparisons; a later version should freeze stop/target at snapshot capture time.
- Source POI phase may become invalidated on the same bar that crosses midpoint; a broker could have filled before or after its invalidation. Snapshot counting does not resolve sequencing.
- Key-cap and active-trial capacity constraints remain; observe the Capacity skip and Ledger limit diagnostics.
- The audit table may become busy on small screens, but no shadow price boxes or new trade labels are drawn.
- Results must be compared over equal historical windows, calibrations and provider symbols/timeframes. The prior screenshots are not controlled paired-trade backtests.

## TradingView acceptance test
1. Compile P17.26.3 on SPX500USD, AUDUSD and US30USD at 5m, 15m and 1H. If Pine reports an error, provide message and line.
2. Under 14B enable Display midpoint shadow audit table and leave midpoint shadow audit on.
3. Compare pre-lifecycle touch totals against P17.26.2 using identical chart/history conditions. Additional snapshots first touched on their retirement/inversion bars can raise total observations and change outcome percentages.
4. Inspect Retired on touch versus counts of OB->BB / FVG->IFVG phase changes. The measure is not restricted to genuine retirement-only cases.
5. Confirm touch uncertainty remains conservatively classified and active M/R trial retention stays bounded without evictions.
6. Compare existing NORMAL/EARLY/MISS REV/CONT labels and live SL/TP1–TP4 against P17.26.2. They should be unaffected by shadow-only code.
7. If the user confirms compiling and consistent chart behavior, next proceed to P17.27 OTE shadow design with confirmed impulse anchors, or freeze snapshot-derived stop/target at prior close first.