# ARTHA P17.22 — Confirmed HTF Multi-Zone Candidate Registry

Status: engineering draft committed, not yet compiled or replay-validated in TradingView. P17.21 last visually validated baseline. P17.19.1 was skipped and not merged.

## Implemented
- Source-observed HTF OB/BB candidate events are retained in a bounded, independent execution-chart array. Each candidate has birth/origin time, bounds, original direction, state (OB, BB, retired), mitigation percentage, source observation time, and box handle.
- New MTF settings: Enable confirmed HTF multi-zone registry, Show HTF registry diagnostics, Maximum imported zones (24 default).
- Each update uses the previous COMPLETED HTF bar through request.security with lookahead-on, once per new source bar. Prior candidates are not displaced when newer candidates appear.
- Retired candidates cease extending, active records get independent display; diagnostic table counts active OB/BB, imported, retired and observed flips.
- Existing P17.21 candidate-to-native OB audit remains; existing native REV/CONT, HTF FVG entries, stops and managed TP1–TP4 unchanged.
- HTF OB/BB candidates remain VISUAL-ONLY, never allowed to trigger trade entries.

## Known limitations
- The source HTF OB detector is the prior approximate candidate model, NOT a source-timeframe execution of the full native ARTHA structural/episode/primary FVG engine. Exact parity is NOT established.
- Multiple zones are stored on the lower chart, but the HTF detector still exports the latest candidate only. Short-lived source zones may be missed and lifecycle may differ from native 15m chart.
- The lower-chart retirement and flip checks are provisional, using confirmed source OHLC; the candidate's real source-engine state is authoritative only for its currently exported candidate.
- Historical rectangle origin is provenance only: it does not permit pre-confirmation trades.
- The skipped P17.19.1 session line visibility change remains unmerged.

## Mandatory validation
1. Compile P17.22 on GBPUSD 5m with POI source 15m; inspect historical overlapping candidates and registry statistics.
2. Compare native GBPUSD 15m OB birth, origin, exact bounds, mitigation and retirement with corresponding imported candidates; report mismatches.
3. Confirm only one registry update per completed 15m bar, and no duplicate source IDs across its three constituent 5m candles.
4. Run on XAUUSD 5m/source 1H and long histories; check box limits and historical offset faults.
5. Verify existing REV/CONT and HTF FVG entries and fixed-R/liquidity exit outcomes match P17.21 under identical settings.

Next: extract exact native episode and structural FVG engine into source-TF execution, then multi-zone native ID export and independent HTF OB/BB/IFVG entry admission after parity.
