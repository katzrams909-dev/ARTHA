# ARTHA v2 P17.26.5 — Execution Audit Reliability

## Status
Source and documentation committed to branch artha-v2-p17-presets. **TradingView compilation and runtime validation pending.** Derived from P17.26.4, preserving the confirmed P17.25.3 native POI system and all REV/CONT/EARLY/MISS production entry logic.

## Why P17.26.5
Previous chart samples showed enormous variation in one-minute intrabar coverage: AUDUSD 1H inspected 13 of 381 touches, whereas AUDUSD 5m inspected 547 of 547. The combined resolved-only 1R rate mixed LTF-ordered decisions with chart-candle OHLC fallbacks. Those groups are not interchangeable. Existing midpoint-vs-reclaim percentages likewise compared different sets of source POIs.

## Changes
- **Evidence provenance**: each completed midpoint trial is classified as LTF-sequenced or OHLC fallback. The dashboard separately reports win / loss / uncertain totals and resolved-only rates for each category. Timeout trials are excluded from resolved percentage.
- **Coverage**: displays intrabar inspection availability as a percentage of first-touch observations, with a LOW status if below 80% (heuristic warning threshold, not statistical certification). Coverage = inspected / (inspected + unavailable). This exposes why 1H samples may be difficult to interpret.
- **Paired-case study**: the existing shadow midpoint record and any later confirmed midpoint-reclaim close entry are joined by source engine + source POI ID + phase kind. Terminal outcomes are retained in distinct maps. A single pair is counted once when BOTH models reach terminal outcomes. The dashboard reports both win, midpoint-only win, reclaim-only win, both loss, and noncomparable pairs (timeout/uncertain). The paired win/loss rows include only determinate +/-1 outcomes.
- **POI disappearance reasons**: on a previously confirmed midpoint touch, distinguish a source phase that inverted (FVG to IFVG or OB to BB), a retained source record in retired state, and a source removed/filtered/trimmed from the visible registry. The pre-existing Retired on touch total is retained as a broad 'phase absent' total; finer reasons appear below it.
- **No evictions or rearming**: preserve unresolved shadow trials and the phase de-duplication map. Capacity skips / key-limit counts remain visible.
- **No changes to live entries**: REV, CONT, EARLY, MISS and existing risk plans, native structural stops, TP1–TP4, mitigation and zone drawing are unchanged.

## What the statistics DO and DO NOT show
- LTF resolved-only rate is calculated only on classified LTF decision events (including later-bar LTF decisions); OHLC fallback rate is separate. Neither includes fees/spread nor proves actual order fills.
- An LTF data-available touch candle can still be ambiguous if multiple events happen within the same lower-timeframe candle; it is not automatically 'verified'.
- 'Paired resolved' excludes cases where one or both models ended uncertain, timed out, or never formed. There can be significant selection bias in which source POIs provide both a midpoint touch and a later qualifying reclaim.
- Both entry models use their existing independent synthetic price geometry; there is no claim that a reclaim-close entry would execute at its modeled close in a real broker.
- 'Inversion' only counts the expected original FVG/OB phase turning into IFVG/BB. If an IFVG or BB source disappears while already in phase 1, it is not misclassified as a new inversion.
- Classification depends on source registries after the bar closes; registry trims or user-configured eligibility filters may place a record in removed/filtered. The original cause may require chart replay for definitive attribution.
- Lower timeframe OHLC is not tick-by-tick. Intrabar gaps, differences between chart OHLC and LTF data, spread and historical availability remain limitations.
- The table is intentionally larger (25 rows x 7 columns) and is optional under G14B.

## Acceptance testing
1. Compile P17.26.5 on AUDUSD 5m, 15m and 1H. Send exact error and line if compilation fails.
2. Turn Display midpoint shadow audit table ON under 14B. Use 1-minute inspection where eligible.
3. Compare current matched intervals with P17.26.4. The original headline totals should be consistent apart from the added audit accounting; unchanged closed-bar entry and structural risk outputs are mandatory.
4. Confirm LTF coverage is approximately full on 5m where data is available, partial on 15m, and appropriately flagged LOW on the historic 1H test when only a small proportion is available.
5. Check that LTF W/L/? and OHLC W/L/? add up to classified midpoint outcomes (wins + losses + ambiguous); timeouts/active positions intentionally excluded.
6. Verify paired counts only grow after both source-phase outcomes close, not merely when an EARLY signal appears.
7. Replay FVG->IFVG and OB->BB, observe inversion vs retirement vs removed/filtered attribution.
8. Check capacity skip remains zero and keys are never recycled; compare previous entry labels and existing plan TP/SL to P17.26.4.

## Development gate
Keep midpoint and OTE orders disabled. If Pine compiles and statistics pass, freeze P17.26.5 as evidence-quality checkpoint; then develop P17.27 OTE as another observational model with causally confirmed impulse anchors.

References: TradingView Pine Script v6 other timeframes/data, https://www.tradingview.com/pine-script-docs/concepts/other-timeframes-and-data/ .