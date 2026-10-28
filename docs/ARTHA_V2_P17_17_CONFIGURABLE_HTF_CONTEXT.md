# ARTHA v2 P17.17 — Configurable Confirmed HTF Context

## Status
First integration draft committed. **Not compiled or chart-tested in TradingView.** P17.16 source is unchanged. No live broker execution; ARTHA manages simulated plans.

## Scope implemented
- New `03A Multi-Timeframe Context` settings: POI source timeframe (default 60m); liquidity target timeframe (default 60m); optional HTF-FVG alignment admission rule (disabled by default); HTF FVG boundary plots; optional HTF swing liquidity in TP3/TP4.
- HTF FVG state computed **inside the requested higher timeframe**, returning prior completed HTF values with `lookahead_on`. The reference is a retained last active bullish/bearish FVG; invalidated by an opposing close through its outer boundary. An FVG is not an HTF OB/BB and is not equivalent to the full existing local POI registry.
- HTF swing liquidity uses last confirmed external pivot highs/lows from selected target timeframe, offset by one completed target bar. Targets are included only beyond TP2/TP3 with the configured minimum separation, and nearest eligible price wins against existing liquidity registry candidates.
- Native chart-timeframe REV/CONT signal generation and admission remain as before. `Require HTF FVG alignment` filters *risk plan acceptance* only, not native signal generation. It checks the signal closing price within same-direction confirmed HTF FVG; by default it is **off**, so native entries are not discarded.
- Matching accepted native trades show `HTF FVG <TF>` provenance in their entry text. Fixed TP1=1R and TP2=2R, and existing P17.16 staged TP3/TP4 ladder, remain unchanged.

## Explicitly not yet implemented
- Independent HTF OB/BB reconstruction, full HTF POI registry, and HTF-POI-triggered entries independent of existing native REV/CONT events.
- Separate 15m signal generation while viewing a 5m chart, or simultaneous multiple HTF POI timeframe pools. Source timeframe is selectable but single-valued.
- Source attribution on TP3/TP4 labels (`HTF swing` vs registry) and historical versions of the HTF context at the exact signal candle; only the causal snapshot is used at entry.
- This draft does not yet satisfy the complete `HTF-POI -> LTF confirmation` independent-entry design. It is a conservative integration step rather than a replacement of ARTHA's signal architecture.

## Mandatory tests
1. Pine compile and full history runtime replay, especially former dynamic-history error at bar 5805.
2. Compare P17.16 against P17.17 with `Require HTF FVG alignment=false` and `Include confirmed HTF swing liquidity=false`: native entry count, SL, TP1 and TP2 must match on identical symbol/timeframe/settings.
3. On a 5m chart, change POI source 15m/1H; confirm FVG levels update only after source candles close. Confirm no intrabar lookahead/repaint.
4. Switch target source 15m/1H; verify TP3/TP4 choose a qualified HTF swing when nearest beyond TP2 and retain other liquidity candidates when nearer.
5. With alignment filter on, trades outside same-direction HTF FVG should have risk plans rejected with diagnostic; with filter off, all previous native plans remain eligible.
6. Validate buy/sell, session DST, missing data, and user-set POI/target timeframe <= chart timeframe (the MTF module is disabled for non-higher requests).
7. Stress label/line object and tracking limits on extensive 1m/5m history.

## Next extension
A separate HTF POI signal-admission path should be developed using stable POI IDs and independently tracked native entries, then OB/BB and multi-zone registry can be added while preserving source-independent trade accounting.
