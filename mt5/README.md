# ARTHA MT5 — P01 foundation

Status: **source drafted; MetaEditor compilation and MT5 chart testing pending**.

Reference: ARTHA TV P17.27.14.14 / P17.27.14.14N, feature-frozen at commit `b2bd697e5b0f1fec5110af90141c59742e1460e0`.

## What this file does

`indicators/ARTHA_MT5_P01_Core.mq5` is a **non-trading** MT5 custom indicator. It:

1. Processes only closed bars (`shift >= 1`), rebuilding deterministically from closed history after refresh or missed bars.
2. Confirms internal and external swing pivots after their right-side strength bars; tracks basic BOS / opposite-trend CHoCH and draws optional horizontal structure-break lines.
3. Recognizes raw three-candle bullish gaps (`low[bar] > high[bar-2]`) and bearish gaps (`high[bar] < low[bar-2]`), with minimum gap size relative to MT5 ATR(14).
4. Tracks the maximum single-candle percentage overlap of each FVG and its first touch after birth; optionally retires the zone on full-wick traversal.
5. Draws bounded native chart rectangles with tooltips; defaults to outlines to preserve candle readability. Its unique `InstanceId` controls chart-object ownership.

## What is intentionally **not** implemented yet

There are **no entry signals, alerts, managed trades, SL/TP levels, or orders**. P01 must not be mistaken for the complete ARTHA indicator or an EA.

The following remain for subsequent releases: displacement episode scoring and FVG provenance filters; FVG primary/secondary selection; IFVG/OB/BB; full BOS/CHoCH/MSS classification; liquidity/session/HTF logic; REV and CONT setup engines; EARLY, confirmed, NORMAL, MISS, MID and MIT entries; OTE; risk plans and TP3/TP4; signal labels/dashboard. P01 structure-break classification is **provisional** and does not yet identify MSS.

## Compile/install in MT5

1. Download `ARTHA_MT5_P01_Core.mq5` from `mt5/indicators/` in the `artha-mt5-p01` branch.
2. Open MetaTrader 5 and MetaEditor (F4).
3. In the MT5 data folder, place the source under `MQL5/Indicators/ARTHA/` (create the ARTHA folder if needed).
4. Open the source in MetaEditor and press **F7** to compile.
5. Record the exact errors/warnings if any. This environment cannot execute MetaEditor, so compilation requires user confirmation.
6. Attach **ARTHA MT5 P01 (Core only)** to a 15m chart. Start with defaults: internal/external pivots 2/5, ATR FVG minimum 0.10, 30 max zones.

## First parity checks

| Check | Expected result | Caveat |
| --- | --- | --- |
| Compile | Zero MetaEditor errors | Not yet run |
| First launch | Only FVG rectangles and external break lines | P01 intentionally shows no buy/sell labels |
| Completed candle | FVG can be created only after its third candle closes | No signal at the live candle (`shift 0`) |
| FVG geometry | Bullish zone = low of third candle to high of first; bearish = low of first to high of third | Compare with Pine set to `FVG creation mode = All` and matched ATR minimum; other Pine filters can hide zones |
| Mitigation | Zone tooltip shows maximum closed-bar overlap percentage | Not an admission decision yet |
| Full fill | Zone stops extending and turns gray if retirement enabled | Not IFVG inversion yet |
| Pivot | External pivot confirmed 5 closed bars after candidate | Pine's advanced structure state not ported |
| Refresh | Same closed-bar drawing result on identical OHLC history | First run only scans `HistoryBars` |

For strict comparisons, ensure identical broker quotes, session times, timeframe, history and inputs. A NAS100 CFD feed from one broker may have materially different candles from TradingView's OANDA feed. Pine's displacement-linked FVG default and secondary-zone visibility are **not** the same as this P01 raw-FVG preview.

## Safety

P01 never calls trade execution APIs. No performance, win-rate, or live-trading claim is made. Do not use P01 markings alone as trade instructions. First target after compile confirmation: **P02 displacement episodes, causal FVG provenance and lifecycle parity**.
