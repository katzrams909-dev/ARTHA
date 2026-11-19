# ARTHA MT5 P10 — integrated indicator beta

**File:** `mt5/indicators/ARTHA_MT5_P10_Complete_Indicator_Beta.mq5`

**Reference:** ARTHA TradingView P17.27.14.14 / 14.14N, frozen 2026-11-16.

This is one integrated, non-trading MT5 indicator draft. It is **not yet a certified 1:1 port** of the 4,000+ line Pine script. It should be compiled in MetaEditor, visually inspected, and calibrated against the frozen TradingView source before declaring parity. P01/P02 stay unchanged.

## Implemented in this beta

- Closed-bar-only confirmed internal and external swings, BOS/CHoCH, configurable break-close rule and structure drawing.
- Displacement scoring, episode archive and provenance; FVGs attributed to displacement and structural breaks.
- FVG mitigation depth, one-way IFVG flips, episode-linked OBs and breakers.
- Confirmed swing liquidity and **previous completed** day/week/month highs and lows, including sweep and takeout tracking.
- REV/CONT admission with separate configurable score thresholds and EARLY, CONF, MIT/MID, MISS and OTE entry paths. All admission happens on bar close.
- Structural SL beyond POI and external swing with ATR buffer and maximum-risk filter; TP1/TP2 risk multiples; optional liquidity-based visual TP3/TP4.
- Independent chart-only trade plans, single label per entry, gray risk zone, cyan long / purple short reward zone, chart dashboard and opt-in alerts.
- Deterministic replay of closed candles on load or on missed-bar recovery; no developing-bar signals or broker order calls.

## Known differences from the TradingView indicator

- Pine's full REV/CONT scoring, advanced MSS/confirmation states, session confluence, and liquidity ranking are **approximated** here.
- OTE uses confirmed external swing anchors rather than the full minor/major/HTF OTE archive and grading system.
- The TradingView display and configuration are much larger; visual parity and exact signal timing are **not guaranteed**.
- MetaEditor compilation and Strategy Tester behavior have **not been verified** in this environment. The file is source-ready for user compilation, not pre-certified.
- Plans are indicator simulations, **not orders or backtest fills**. If TP and SL both fall inside the same subsequent candle, conservative stop-first resolution is used. Targets cannot be credited on the admission candle.
- Fully resolved plans and signal labels can be pruned to respect display limits. **Open plans are never pruned** by those limits.

## Install and validate

1. In MetaEditor, create a new *Custom Indicator* named `ARTHA_MT5_P10_Complete_Indicator_Beta` (or open the supplied `.mq5` under `MQL5/Indicators`). Replace the template with the complete file.
2. Press **F7** and report the exact first error, if any. Please include its line number and error message. A compiler success message is necessary but not sufficient.
3. In MT5, attach P10 to a **demo chart**; start with **EURUSD M5** (where P01 loaded), then compare **NAS100 and SPX500 M15** to screenshots from the frozen TradingView version.
4. Record whether structure/FVG/IFVG/OB zones appear, whether REV/CONT entry labels appear, and whether the entry and structural SL/TP levels seem plausible.
5. Verify that refreshing the chart does not move past signals; then watch a live candle form to ensure no signals appear before its close.
6. Compare the **same broker feed, timeframe, and time range** when possible. Different broker/session candles may generate different FVGs and breaks.
7. Keep `InpAlertOnNewSignals=false`, `InpPushOnNewSignals=false` until chart behavior is reviewed. The indicator itself never executes orders.

## Next validation gate

Collect MetaEditor output plus screenshots from at least two symbols/timeframes. Once the file compiles and produces sane signals, investigate remaining Pine-versus-MQL5 discrepancies and build a P11 revision. A separate EA will be required for any future automated execution.
