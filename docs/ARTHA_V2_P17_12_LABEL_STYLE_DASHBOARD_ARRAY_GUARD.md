# ARTHA v2 P17.12 — Label Style, Dashboard & Array Guard

- Based on P17.11; prior versions are unchanged.
- Fixes the runtime error at the same-bar marker cleanup loop by guarding the reverse iteration with `array.size(signalLabels) > 0`.
- Adds reference-inspired badge/text-only signal label styles and optional emoji suffixes. Existing label prefixes remain intact for signal arbitration and risk-plan marker matching.
- Adds independent signal label background/text colors and transparency.
- Adds display controls and color inputs for confirmed higher-timeframe fast/slow EMA plots. EMA lengths and timeframe remain configurable in the trend-filter settings.
- Adds an optional setup dashboard with trend status, structure bias, latest signal state, plan status, entry, stop, T1 and T2. Dashboard position, size, and palette are configurable.
- Retains ARTHA's liquidity targets, structural risk model, risk/reward shaded areas, outcome handling, and causal confirmed HTF values.

## Validation status
Not compiled or visually validated in TradingView. The user must compile and verify before relying on it.