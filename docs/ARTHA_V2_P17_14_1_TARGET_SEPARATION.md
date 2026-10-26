# ARTHA v2 P17.14.1 — Managed vs Visual Liquidity Target Separation

## Status
Draft committed, not yet compiled in TradingView. P17.14 was shown running in user screenshots; P17.13.1 previously explicitly compile-confirmed.

## Screenshot finding
The US30USD 5-minute entry screenshot showed managed TP1 52643.4 (3.08R), managed TP2 52651.7 (3.17R) and visual TP3 52978.9, instead of the earlier primary target structure. The completed-session levels entered the same registry used by managed TP1/TP2 and displaced the intended managed targets.

## Correction
- `f_activeLiquidityT1` and `f_activeLiquidityT2` now exclude sources with `sourceType` prefix `SESSION_`. Other pre-existing liquidity families and fallback R models retain their previous selection rules.
- `f_visualLiquidityBeyond` remains permitted to select completed session highs/lows, as well as the other active liquidity families, ordered by the nearest qualified candidate beyond managed TP2/TP3.
- Primary TP1/TP2 continue driving current simulated execution and realized-R accounting. TP3/TP4 remain informational.
- No change to session definitions, session registry lifecycle, entry/stop logic, or plan persistence.

## Validation
1. Compile P17.14.1 Pine v6.
2. On US30USD compare primary TP1/TP2 to pre-session P17.13.1 under otherwise identical inputs and historical bars; avoid assuming exact prices if signal data or settings differ.
3. Confirm qualifying nearby session levels appear as TP3/TP4, without inventing missing targets.
4. If only one extended liquidity candidate exists, TP4 should say `NO ELIGIBLE LIQ`.
5. Verify longs, shorts, session boundaries, and unchanged partial exit and stop-first accounting.
