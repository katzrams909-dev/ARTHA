# ARTHA V2 — P17.27.14.7 Multi-bar POI Reclaim Audit

## Baseline / screenshots

P17.27.14.6 was confirmed to compile by user's screenshots, and on 15m XAUUSD, NAS100, GBPUSD, AUDUSD, USDCAD, USDCHF the dashboard shows nonzero midpoint audit observations (M) and historical plan counts. Orange `POI 50%` labels are produced by the indicator and are **not equivalent** to the user's independently drawn reference entry arrows. NAS100 and AUDUSD show why unfiltered reaction markers should **not** be promoted straight into live orders: earlier bearish EARLY entries may be stopped during a subsequent bullish move.

## Main diagnosis

P17.27.14.6's auxiliary 50% audit required the wick penetration and directional closing reclaim **on the same candle**. Native NORMAL supports cumulative penetration on a retest bar and a directional boundary close within `normalConfirmBars`; however, the native setup additionally requires pre-existing valid REV/CONT episode state, selected native POI, score, conflict/dedup, and risk-plan admission.

## Implementation

- Replaced the single-bar audit predicate with a bounded **per-native-POI touch ledger**. Touch is recorded only when the POI is already born, active on the current confirmed candle and the candle intersects the POI's 50% midpoint.
- A reclaim is recorded on the **current confirmed candle** if its directional close has crossed outside the favorable POI edge and the most recent touch is at most `normalConfirmBars` old.
- The orange diagnostic labels append `0b`, `1b`, etc. indicating how many bars elapsed since that POI's most recent 50% touch.
- It records no more than one confirmed reclaim per native POI key in the rolling ledger, and at most one diagnostic label per candle. Pending and completed keys have bounded retention; historical observations are drawings only.
- Retains the `M` dashboard counter. OTE scale attribution is observational and **does not turn the marker into an independent OTE trade**.
- **No changes** to native NORMAL/EARLY/MISS, REV/CONT arbitration, structural stops, the maximum three-ATR risk gate, targets, alerts, accepted-plan identity or causal HTF confirmation.
- The change adds only ~600 source characters over P17.27.14.6. Compiled-token change is **unknown** until TradingView tests it; Pine token count is not source length.

## Validation protocol

1. Compile `pine/v2/ARTHA_V2_P17_27_14_7_Multibar_POI_Reclaim_Audit.pine`. P17.27.14.6 is the last known compile-confirmed fallback.
2. On 15m XAUUSD, NAS100, GBPUSD, AUDUSD, USDCAD and USDCHF, enable `Audit 50% POI touch → reclaim (not an entry)`, `Show setup dashboard`, and `Show signal-flow diagnostics`. Use `Production OTE confluence = Off` to isolate native risk admission.
3. Compare user-marked arrows with diagnostic labels. Distinguish 0b and delayed 1–5b markers, and note genuine missed setup types that have no reclaim.
4. Compare `M` count vs the prior P17.27.14.6 and confirm `S/R/P` are unchanged across matching symbol, timeframe, history and settings, because this is a shadow-only change.
5. Do not assume matching a hindsight manually-marked entry proves availability on its candle; use Bar Replay for causal timing and check POI birth/confirmation.
6. If new build compiles but valid user examples still lack M markers, the likely models to audit separately are unconfirmed limit-entry at midpoint, early touch-close within the favorable half, displacement-retest without a reclaim, or genuine OTE-only independent entries.

## Constraints / known limitations

This is **not a new executable entry model**. It does not classify all manual example trades. The use of a rolling 120-key memory and dedup means chart-history loaded length can affect very old audit observations; never use the M counter as backtest evidence.
