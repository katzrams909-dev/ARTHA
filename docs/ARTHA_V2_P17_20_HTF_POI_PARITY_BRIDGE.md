# ARTHA P17.20 — HTF OB/BB Candidate Bridge and Parity Gate

**Status:** Pine source committed; not TradingView compiled or runtime validated. P17.19 remains the user's last compile-confirmed baseline. P17.19.1 was explicitly skipped and not merged.

## Motivation
On GBPUSD 15m the user marked a bearish OB retest; that native 15m OB was absent on 5m. P17.19 imported HTF FVGs, not the source timeframe native OB registry.

## What this change adds
- A source-timeframe OB/BB candidate computed in request.security using prior completed source bars and lookahead-on; it uses source-frame pivots, breaks, ATR displacement, structural FVG and an opposite-candle-origin search.
- Source-labelled OB candidate / BB candidate rectangle on the execution chart, plus an independent display switch and origin-search length.
- Basic source-timeframe OB-to-BB flip, retirement, source origin metadata, and no access to unconfirmed HTF bars.
- Native trades and HTF FVG entries, stops and staged TP1–TP4 are unchanged.

## Critical limitation: source parity NOT achieved
The candidate bridge is *not* the full native ARTHA order-block engine. Native OB construction requires displacement-episode aggregation, primary structural FVG election, episode-linked source candle selection, and complete multi-zone lifecycle. This preview may miss native OBs and may show other candidate zones. It tracks one source candidate, not a complete registry.

**HTF OB/BB candidates are VISUAL ONLY, not permitted to create trades.** The work should not be described as matching the 15m OB on the 5m chart until same-origin, same-price, same-state comparisons succeed.

## GBPUSD 15m → 5m acceptance
1. Compile full script, then compare the 15m bearish OB's native upper/lower prices, source origin, birth and state to its 5m imported counterpart.
2. If values differ, treat as failed parity and refactor the native source engine rather than tuning a chart-tolerance shortcut.
3. Check no regressions to native signal counts, FVG entries, SL, TP1 1R, TP2 2R and TP3/4 allocation.
4. Confirm confirmed HTF snapshot display can be anchored historically for visual provenance but no historical entry predates source bar confirmation.
5. Test 15m/1H sources on 5m and 1m charts, and long histories for resource limits.

## Next engineering phase
Encapsulate native displacement / structure / primary FVG / OB lifecycle into a source-timeframe-safe engine with stable IDs and multiple concurrent POIs, then implement exact HTF source snapshot imports and entry admission. Include IFVG and breaker parity after OB parity. Do not activate HTF OB entries before this gate.
