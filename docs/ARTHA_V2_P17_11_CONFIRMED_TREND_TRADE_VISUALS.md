# ARTHA v2 P17.11 — Confirmed Trend Filter & Trade Visuals

## Scope
- New version based on the current P17.10 source; previous versions remain unchanged.
- Optional combined trend admission filter, disabled by default.
- Confirmed higher-timeframe EMA alignment (default 1 hour, fast 20 / slow 50).
- Confirmed market-structure bias using pivots that only become available after right-side confirmation and a confirmed close through the latest swing.
- When enabled, bullish signals require bullish HTF EMA alignment and bullish structure bias; bearish signals require the opposite.
- Shaded risk and reward areas accompany existing entry, stop, T1 and T2 lines/labels, with configurable fill colors and transparency.
- Existing setup, POI, reaction, stop, target and outcome models are otherwise intended to remain unchanged.

## Non-repainting design
The HTF EMAs are requested from the prior completed HTF bar using the [1] offset with barmerge.lookahead_on. Structure bias updates only on confirmed chart bars and only from confirmed pivots / close breaks.

## Important validation note
This version has not been compiled or visually validated in TradingView. The user must compile and visually inspect it before relying on it.