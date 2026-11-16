# ARTHA TradingView v2 — feature freeze / MT5 handoff

Date: 2026-11-16  
Original source branch: `artha-v2-p17-presets`  
Immutable reference commit: `b2bd697e5b0f1fec5110af90141c59742e1460e0`  
Snapshot branch: `artha-tv-p17-27-14-14-freeze`  
Next development branch: `artha-mt5-p01`

## Frozen TradingView sources

- Full OTE: `pine/v2/ARTHA_V2_P17_27_14_14_Mitigation_Retest_Entries.pine`
- No OTE: `pine/v2/ARTHA_V2_P17_27_14_14N_No_OTE_Mitigation_Entries.pine`

**Freeze means no feature changes to these files.** If a verified defect is found, create a separately named maintenance version; do not rewrite the reference files or their history.

## User-reported validation

- Both variants compile in TradingView Pine v6.
- Both variants display entry signals.
- Screenshot evidence on 2026-11-16 shows EARLY, OTE, and MIT sell entries, with MIT 25% mitigation/favorable-half confirmation and coherent 1R/2R target arithmetic on 15-minute NAS100/SPX500 charts.
- Screenshot tooltips are historical, while setup panels can show a different currently selected/active plan; panel synchronization has not been independently audited.

**Not verified:** strict bar-for-bar non-repainting, all threshold/confirmation combinations, cross-market performance, no-OTE/OTE equivalence with OTE disabled, historical/backtest results, or suitability for live execution. “Feature-complete” is not a trading-performance claim.

## MT5 port contract

The MQL5 code must preserve, in future milestones:

1. Confirmed-bar causal state and pivot confirmation delays (no forward knowledge).
2. Internal/external BOS, CHoCH/MSS, sweep/structure context.
3. Displacement episodes and provenance-linked FVG/IFVG/OB/BB in one POI registry.
4. Independent REV and CONT engines, EARLY vs Confirmed, NORMAL/MISS/MID/MIT with configurable mitigation thresholds, then the separate OTE model.
5. One entry label with reason, structural stop, independent concurrent plans, TP1/TP2 management and visual TP3/TP4.
6. Historical outcomes, configurable session/HTF context without consuming forming HTF data, and bounded chart-object/runtime behavior.

Pine functions and MQL5 events have different execution semantics. Compare closed-bar event logs before treating visual or trading results as equivalent. TradingView and MT5 broker OHLC histories may differ; use an identical exported OHLC dataset for strict parity tests where possible.

## Implementation sequence

- **P01:** non-trading closed-bar structure/FVG geometry and mitigation tracking (the first MQL5 file).
- **P02:** displacement scoring/episodes, provenance, FVG lifecycle and IFVG.
- **P03:** order blocks, breakers, unified POIs, liquidity registry.
- **P04:** REV/CONT state machines, EARLY/confirmed/MISS/MID/MIT admissions and parity tests.
- **P05:** OTE extension, trade plans, structural SL, TP1–TP4, labels and dashboard.
- **P06:** optional MT5 Expert Advisor, position sizing, order routing, broker constraints, simulation and risk interlocks—only after indicator parity.

The **no-OTE Pine edition** is the first parity target, followed by full OTE. No EA or live orders are in scope for P01.
