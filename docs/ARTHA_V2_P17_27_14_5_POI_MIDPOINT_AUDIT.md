# ARTHA P17.27.14.5 — Causal 50%-POI Reclaim Audit

## Basis
User confirmed P17.27.14.4 **compiles** in TradingView. The screenshots with orange arrows were user-marked valid setup/trade benchmarks, not ARTHA-generated arrows.

## New functionality (study-only; no trade admission change)
- The new `Show 50% POI reclaim audit` option is rendered in Section 14 as `Audit confirmed POI 50% reclaim (not an entry)`, default ON.
- On a **confirmed chart candle**, scan **current native unified POIs only**. POI must have been born on an earlier bar (`p.bornBar<bar_index`). Existing `f_normalFill` and `f_normalReclaim` must both be true.
- This observes a >= configured NORMAL POI penetration (default 50% by candle wick), followed by a directionally appropriate close outside the POI's entry-facing edge on the **same confirmed candle**. It does **not** infer earlier unobserved retests or create signals retroactively.
- Up to **one** new orange `POI 50% · TYPE#ID` audit label per bar, and at most one per native POI key while tracked. Keeps up to 25 audit labels and 120 dedup keys.
- Adds `M` counter to the SIGNAL FLOW diagnostic row, counting audit detections. A qualifying confirmed OTE source is included in the marker when available.
- **No execution, alerts, signal score, risk-plan creation, trade statistics changes, or relaxed protective gates.** Existing NORMAL, EARLY, MISS and OTE confluence flows are unchanged. The audit intentionally does not claim every marker is executable or a fully validated SMC/ICT setup.

## Comparison with marked examples
- Orange user arrows on GBPUSD, USDJPY, AUDUSD, USDCAD 15m are qualitative examples. A different location/time for an audit marker does not alone establish a detection bug; review POI born, touch depth, close location and the chart candle's confirmed state.
- If audit marker appears near user's marked entry but no ARTHA signal, problem is likely in native REV/CONT context, quality, arbitration or risk admission. Use S/R/P counters to distinguish.
- If audit marker absent, compare whether the user's entry model requires first-touch, intrabar entries at 50% without reclaim, a previous-bar deep fill and later reclaim, OTE-only confluence, or another confirmation. The new audit tests specifically **same-bar 50% reclaim**.
- OTE display is confirmed confluence only, not an independent OTE trade engine in this version.

## Compile status
New .14.5 is **NOT compiled in TradingView**. P17.27.14.4 is last user-verified compiling version. Pine token budget is tight (CE10117 possible); report exact token count if so. Preserve .14.4 for rollback.
