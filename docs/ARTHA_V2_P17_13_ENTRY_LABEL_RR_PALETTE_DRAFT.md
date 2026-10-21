# ARTHA v2 P17.13 — Entry Label and RR Palette (draft)

## Status
**Uncompiled / unverified in TradingView.** Based on user-confirmed compiling P17.12.1. Earlier versions unchanged.

## Changes in this focused iteration
- Risk area defaults to gray.
- Bullish reward area defaults to cyan `#00BCD4`; bearish reward area defaults to purple `#9C27B0`. Reward transparency remains configurable.
- Accepted trades with an entry plan label remove the redundant candle signal marker. Existing same-bar signal arbitration and risk rejection happen before marker removal.
- One trade entry tag includes direction, REV/CONT, recorded NORMAL/EARLY/MISS source, score, grade, entry, ACTIVE status, and factual entry context (POI type/ID and episode ID).
- Added source-at-admission tooltip for the entry tag. The wording is a summary of available recorded evidence, not a new inference of why the setup was admitted.
- Existing TP1/TP2, structural stops, outcome accounting, signal admission, and confirmed HTF requests remain unchanged.

## Important pending items
- This iteration does **not** remove age-based expiry or implement TP3/TP4. The current `riskPlanMaxAgeBars` and `maxRiskPlans` eviction logic must be redesigned together to prevent silently dropping active trades. Also assess `showOnlyLatestActivePlan` visual cleanup separately from internal state.
- No EARLY/confirmed classification logic has changed. That requires a separate causal eligibility audit.
- Label rendering follows the reference's multi-line direction/grade/score motif, but exact parity with its badge lifecycle is not claimed.
- The legacy `rewardAreaColor` input remains for settings compatibility but the directional inputs control the actual reward box.

## TradingView validation
1. Compile Pine v6 and report the first error if any.
2. Confirm one entry label per accepted trade when plan tags are enabled.
3. Verify bullish cyan / bearish purple reward and gray risk fills.
4. Verify rejected trades do not retain an entry marker.
5. Check REV/CONT and EARLY/MISS entries on historical charts; validate score, source, POI ID, and plan entry match.
6. Confirm SL/TP1/TP2 and trade outcome behavior are unchanged.
